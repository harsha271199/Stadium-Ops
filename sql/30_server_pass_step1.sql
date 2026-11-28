-- ============================================================
-- 30 — Server-checked sign-in, STEP 1: "pass only, no rules yet"
-- ============================================================
-- At sign-in the app asks the server for a pass (issue_pass). The server
-- re-checks the same things the app checks (ID / shared code + last name,
-- Admin PIN, NPO group PIN, ...) and hands back a random pass. The app then
-- sends that pass with every request in the header  x-stadium-pass.
--
-- NOTHING IS BLOCKED in this step. A request with no pass, or a bad one,
-- works exactly like today. The server only writes a small log of which
-- kind of pass made each change (pass_audit), so we can check the access
-- rules against real game-day use before switching any rule on.
--
-- Undo: sql/30_server_pass_step1_UNDO.sql
-- ============================================================

create extension if not exists fuzzystrmatch with schema extensions;
create extension if not exists unaccent with schema extensions;
create extension if not exists pgcrypto with schema extensions;

-- ---------- tables (private: the public key can't read or write them) ----------
create table if not exists public.app_passes (
  token        text primary key,
  kind         text not null,          -- admin | staff | worker | npo | subcontractor | premium_seller
  employee_id  text,
  name         text,
  role         text,                   -- server-side role (staff_accounts.role or schedule role)
  stand        text,                   -- stand the app signed them into (as told by the app)
  npo_group_id bigint,
  issued_at    timestamptz not null default now(),
  expires_at   timestamptz not null,
  last_seen    timestamptz,
  revoked      boolean not null default false
);
create index if not exists app_passes_exp_idx on public.app_passes (expires_at);

create table if not exists public.pass_fail (
  id     bigserial primary key,
  at     timestamptz not null default now(),
  kind   text, code text, reason text
);
create index if not exists pass_fail_code_idx on public.pass_fail (code, at);

create table if not exists public.pass_audit (
  id          bigserial primary key,
  at          timestamptz not null default now(),
  tbl         text, op text,
  pass_state  text,                    -- ok | none | invalid | expired
  kind        text, role text, employee_id text, stand text
);
create index if not exists pass_audit_at_idx on public.pass_audit (at);

alter table public.app_passes enable row level security;
alter table public.pass_fail  enable row level security;
alter table public.pass_audit enable row level security;
revoke all on public.app_passes, public.pass_fail, public.pass_audit from anon, authenticated;
revoke all on sequence public.pass_fail_id_seq, public.pass_audit_id_seq from anon, authenticated;

-- ---------- helpers ----------
create or replace function public.pass_letters(x text) returns text
language sql stable set search_path = public, extensions as $$
  select regexp_replace(lower(extensions.unaccent(coalesce(x, ''))), '[^a-z]', '', 'g')
$$;

create or replace function public.pass_close(e text, t text) returns boolean
language sql immutable set search_path = public, extensions as $$
  select coalesce(e, '') <> '' and coalesce(t, '') <> '' and extensions.levenshtein(e, t) <=
    case when length(t) >= 9 then 3 when length(t) >= 6 then 2 when length(t) >= 4 then 1 else 0 end
$$;

-- Same forgiving last-name match the app uses (loginNameTier > 0).
create or replace function public.pass_name_ok(entered text, full_name text) returns boolean
language plpgsql stable set search_path = public, extensions as $$
declare
  e text := pass_letters(entered);
  nm text := btrim(coalesce(full_name, ''));
  last_raw text; first_raw text; last text; first text; fw text; t text;
begin
  if length(e) < 2 then return false; end if;
  if position(',' in nm) > 0 then
    last_raw := split_part(nm, ',', 1);
    first_raw := substr(nm, position(',' in nm) + 1);
  else
    last_raw := regexp_replace(nm, '^.*\s', '');
    first_raw := case when nm ~ '\s' then regexp_replace(nm, '\s+\S+$', '') else '' end;
  end if;
  last := pass_letters(last_raw); first := pass_letters(first_raw);
  fw := pass_letters(split_part(btrim(first_raw), ' ', 1));
  if last = '' then return false; end if;
  if e in (last, last || first, first || last, fw || last, last || fw) then return true; end if;
  if length(e) >= 3 and left(last, length(e)) = e then return true; end if;
  if length(e) >= 4 and position(e in last) > 0 then return true; end if;
  if length(last) >= 3 and position(last in e) > 0 then return true; end if;
  if pass_close(e, last) or pass_close(e, fw || last) or pass_close(e, last || fw) then return true; end if;
  foreach t in array regexp_split_to_array(lower(extensions.unaccent(last_raw)), '[^a-z]+') loop
    if length(t) >= 3 and pass_close(e, t) then return true; end if;
  end loop;
  if length(e) >= 4 and pass_close(left(e, length(last)), last) then return true; end if;
  if fw <> '' and length(e) >= 3 and (e = fw or pass_close(e, fw)) then return true; end if;
  return false;
end $$;

-- Arizona time; the stadium day rolls over at 6 AM (same as the app).
create or replace function public.pass_next_6am() returns timestamptz
language sql stable set search_path = public as $$
  select ((date_trunc('day', (now() at time zone 'America/Phoenix') - interval '6 hours')
           + interval '1 day 6 hours') at time zone 'America/Phoenix')
$$;

-- ---------- issue a pass at sign-in ----------
-- p_kind        admin | staff | worker | npo | subcontractor | premium_seller
-- p_code        what was typed in the ID box (last 5 / shared code)
-- p_secret      last name, Admin PIN, or NPO group PIN
-- p_employee_id the person the app signed in (npo: member id)
-- p_stand       stand the app signed them into
-- p_group_id    npo group id
-- p_name        npo member name as typed
create or replace function public.issue_pass(
  p_kind text, p_code text, p_secret text, p_employee_id text,
  p_stand text default null, p_group_id bigint default null, p_name text default null)
returns jsonb language plpgsql security definer set search_path = public, extensions as $$
declare
  k text := lower(coalesce(p_kind, ''));
  v_code text := btrim(coalesce(p_code, ''));
  sec text := btrim(coalesce(p_secret, ''));
  eid text := btrim(coalesce(p_employee_id, ''));
  d_today date := (now() at time zone 'America/Phoenix')::date;
  d_stadium date := ((now() at time zone 'America/Phoenix') - interval '6 hours')::date;
  v_role text; v_name text; v_exp timestamptz; v_tok text; n int; ok boolean := false;
  a record;
begin
  -- Slow down guessing: 30 failed tries on one code in 10 minutes → wait.
  select count(*) into n from pass_fail pf where pf.code = left(v_code, 40) and pf.at > now() - interval '10 minutes';
  if n >= 30 then return jsonb_build_object('ok', false, 'error', 'busy'); end if;

  if k = 'admin' then
    select * into a from staff_accounts
     where role = 'admin' and is_active and length(v_code) >= 5 and employee_id like '%' || v_code
       and pin is not null and pin = sec limit 1;
    if found then ok := true; eid := a.employee_id; v_role := 'admin'; v_name := a.name; end if;

  elsif k = 'staff' then
    select * into a from staff_accounts where employee_id = eid and is_active and role <> 'admin' limit 1;
    if found and (
         (length(v_code) >= 5 and a.employee_id like '%' || v_code)
      or (v_code = '60000' and a.role like 'warehouse%' and (a.employee_id like '%60000' or a.pin = '60000'))
      or (v_code = '70000' and a.role like 'premium%' and a.employee_id like '%70000'))
     and (pass_name_ok(sec, a.name) or (sec ~ '^\d{4,5}$' and a.pin = sec)) then
      ok := true; v_role := a.role; v_name := a.name;
    end if;

  elsif k = 'worker' then
    -- Workers: on today's (or last night's) schedule. Leads and supervisors
    -- can sign in on any day, like the app allows.
    select s.role, s.worker_name into v_role, v_name from schedule s
     where s.employee_id = eid and length(v_code) >= 5 and s.employee_id like '%' || v_code
       and coalesce(s.is_test, false) = false
       and (s.event_date in (d_today, d_stadium) or s.role ~* '(lead|supervisor)')
       and pass_name_ok(sec, s.worker_name)
     order by (s.event_date in (d_today, d_stadium)) desc, s.event_date desc limit 1;
    ok := found;

  elsif k = 'premium_seller' then
    select ps.role_title, ps.worker_name into v_role, v_name from premium_schedule ps
     where ps.event_date = d_today and ps.employee_id = eid and length(v_code) >= 5 and ps.employee_id like '%' || v_code
       and pass_name_ok(sec, ps.worker_name)
       and exists (select 1 from app_settings st where st.key = 'bottle_sell_access:' || d_today
                    and eid = any (regexp_split_to_array(coalesce(st.value, ''), '[,\s]+')))
     limit 1;
    ok := found; v_role := 'premium_seller';

  elsif k = 'subcontractor' then
    -- 50000 + stand number: the stand must exist.
    ok := v_code = '50000' and exists (select 1 from stands where stand_name = p_stand);
    v_role := 'subcontractor'; v_name := 'Subcontractor crew';

  elsif k = 'npo' then
    ok := exists (select 1 from npo_groups g where g.id = p_group_id and g.is_active and g.pin is not null and g.pin = sec);
    if ok and eid ~ '^\d+$' then
      select m.member_name, case when m.is_lead then 'npo_lead' else 'npo_member' end into v_name, v_role
        from npo_members m where m.id = eid::bigint and m.group_id = p_group_id and m.is_active;
      ok := found;
    elsif ok then
      v_name := p_name; v_role := 'npo_member';
    end if;
  end if;

  if not ok then
    insert into pass_fail(kind, code, reason) values (left(k, 20), left(v_code, 40), 'no_match');
    return jsonb_build_object('ok', false, 'error', 'no_match');
  end if;

  -- Staff accounts stay signed in (7 days, renewed quietly while the app is
  -- open). Everyone else: until 6 AM, the end of the stadium day.
  v_exp := case when k in ('admin', 'staff') then now() + interval '7 days' else pass_next_6am() end;
  v_tok := encode(extensions.gen_random_bytes(24), 'hex');
  insert into app_passes(token, kind, employee_id, name, role, stand, npo_group_id, expires_at)
  values (v_tok, k, nullif(eid, ''), v_name, v_role, p_stand, p_group_id, v_exp);
  return jsonb_build_object('ok', true, 'pass', v_tok, 'expires_at', v_exp, 'kind', k, 'role', v_role);
end $$;

-- Staff passes: push the expiry out again while the app is in use.
create or replace function public.renew_pass(p_pass text) returns jsonb
language plpgsql security definer set search_path = public as $$
declare v_exp timestamptz;
begin
  update app_passes set expires_at = case when kind in ('admin', 'staff') then now() + interval '7 days' else expires_at end,
                        last_seen = now()
   where token = p_pass and not revoked and expires_at > now()
  returning expires_at into v_exp;
  if v_exp is null then return jsonb_build_object('ok', false); end if;
  return jsonb_build_object('ok', true, 'expires_at', v_exp);
end $$;

-- Sign out: the pass stops working.
create or replace function public.end_pass(p_pass text) returns jsonb
language sql security definer set search_path = public as $$
  update app_passes set revoked = true where token = p_pass;
  select jsonb_build_object('ok', true);
$$;

-- Who is making this request? (for the rules in a later step)
create or replace function public.current_pass()
returns table (kind text, role text, employee_id text, stand text, npo_group_id bigint)
language sql stable security definer set search_path = public as $$
  select p.kind, p.role, p.employee_id, p.stand, p.npo_group_id from app_passes p
   where p.token = nullif(current_setting('request.headers', true)::json ->> 'x-stadium-pass', '')
     and not p.revoked and p.expires_at > now()
$$;

-- ---------- log only: which pass made each change ----------
create or replace function public.pass_audit_trg() returns trigger
language plpgsql security definer set search_path = public as $$
declare tok text; st text; v_kind text; v_role text; v_emp text; v_stand text; v_rev boolean; v_exp timestamptz;
begin
  begin
    if nullif(current_setting('request.headers', true), '') is null then return null; end if;  -- not an app request (SQL editor, cron)
    tok := nullif(current_setting('request.headers', true)::json ->> 'x-stadium-pass', '');
    if tok is null then st := 'none';
    else
      select kind, role, employee_id, stand, revoked, expires_at into v_kind, v_role, v_emp, v_stand, v_rev, v_exp
        from app_passes where token = tok;
      st := case when v_exp is null or v_rev then 'invalid' when v_exp <= now() then 'expired' else 'ok' end;
    end if;
    insert into pass_audit(tbl, op, pass_state, kind, role, employee_id, stand)
    values (tg_table_name, tg_op, st, v_kind, v_role, v_emp, v_stand);
  exception when others then null;  -- the log must never stop a save
  end;
  return null;
end $$;

-- Attach the log to every table the public key can change (not backups).
do $$
declare t text;
begin
  for t in
    select distinct g.table_name from information_schema.role_table_grants g
      join information_schema.tables it on it.table_schema = g.table_schema and it.table_name = g.table_name
     where g.table_schema = 'public' and g.grantee = 'anon' and it.table_type = 'BASE TABLE'
       and g.privilege_type in ('INSERT', 'UPDATE', 'DELETE')
       and g.table_name !~ '(backup|_bak|^_|^archive_|^inv10_|^inv_|stage)'
       and g.table_name not in ('app_passes', 'pass_fail', 'pass_audit')
  loop
    execute format('drop trigger if exists zz_pass_audit on public.%I', t);
    execute format('create trigger zz_pass_audit after insert or update or delete on public.%I for each statement execute function public.pass_audit_trg()', t);
  end loop;
end $$;

revoke all on function public.issue_pass(text, text, text, text, text, bigint, text) from public;
revoke all on function public.renew_pass(text), public.end_pass(text), public.current_pass() from public;
revoke all on function public.pass_audit_trg(), public.pass_name_ok(text, text), public.pass_letters(text), public.pass_close(text, text), public.pass_next_6am() from public, anon, authenticated;
grant execute on function public.issue_pass(text, text, text, text, text, bigint, text) to anon, authenticated;
grant execute on function public.renew_pass(text), public.end_pass(text), public.current_pass() to anon, authenticated;

-- ---------- clean-up: keep the log small (free plan) ----------
-- Every night at 3:17 AM Arizona time: logs older than 30 days, failed
-- sign-in records older than 7 days, passes that ended over 7 days ago.
do $$
begin
  if exists (select 1 from pg_extension where extname = 'pg_cron') then
    perform cron.unschedule(jobid) from cron.job where jobname = 'pass_cleanup';
    perform cron.schedule('pass_cleanup', '17 10 * * *', $c$
      delete from public.pass_audit where at < now() - interval '30 days';
      delete from public.pass_fail  where at < now() - interval '7 days';
      delete from public.app_passes where expires_at < now() - interval '7 days';
    $c$);
  end if;
end $$;
