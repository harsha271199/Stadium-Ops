-- Security step 2 (part A): every change to staff_accounts goes through this
-- checked function. The caller proves who they are on every call:
--   admin / warehouse_manager -> their own employee ID + their own PIN
--   warehouse_supervisor      -> their own employee ID + last name (they share
--                                PIN 60000; same check as their sign-in)
-- What each may do:
--   admin              p_action 'upsert'  : create/edit name, role, PIN, active
--                                           (never an admin account, never role admin)
--   admin / warehouse  p_action 'wh_temp' : create a warehouse_employee with PIN
--   manager/supervisor                      60000, or switch an existing warehouse_*
--                                           login back on. Nothing else.
-- Part B (sql/28_security_step2_GO_LIVE.sql) removes direct INSERT/UPDATE/DELETE
-- from the public key — run it only AFTER the build that uses this is live.
create or replace function public.staff_account_write(
  p_actor_id text, p_actor_secret text, p_action text,
  p_employee_id text, p_name text default null, p_role text default null,
  p_pin text default null, p_is_active boolean default null)
returns jsonb language plpgsql security definer set search_path = public as $$
declare
  a record; t record; norm_last text; ok_actor boolean := false;
begin
  if coalesce(p_actor_id,'') = '' or coalesce(p_actor_secret,'') = '' then
    return jsonb_build_object('ok',false,'error','auth');
  end if;
  -- who is calling
  select employee_id, name, role into a from staff_accounts
   where employee_id = p_actor_id and is_active
     and role in ('admin','warehouse_manager','warehouse_supervisor') limit 1;
  if not found then return jsonb_build_object('ok',false,'error','auth'); end if;
  if a.role in ('admin','warehouse_manager') then
    ok_actor := exists (select 1 from staff_accounts where employee_id = p_actor_id and is_active and pin = p_actor_secret);
  else -- warehouse_supervisor: last name, as at sign-in
    norm_last := lower(regexp_replace(split_part(a.name, ',', 1), '[^a-zA-Z]', '', 'g'));
    ok_actor := norm_last <> '' and norm_last = lower(regexp_replace(p_actor_secret, '[^a-zA-Z]', '', 'g'));
  end if;
  if not ok_actor then return jsonb_build_object('ok',false,'error','auth'); end if;

  if coalesce(p_employee_id,'') !~ '^\d{5,}$' then
    return jsonb_build_object('ok',false,'error','bad employee id');
  end if;
  select employee_id, name, role, is_active into t from staff_accounts where employee_id = p_employee_id limit 1;

  if p_action = 'upsert' then
    if a.role <> 'admin' then return jsonb_build_object('ok',false,'error','not allowed'); end if;
    if p_role = 'admin' or (t.employee_id is not null and t.role = 'admin') then
      return jsonb_build_object('ok',false,'error','admin accounts cannot be changed here');
    end if;
    if p_pin is not null and p_pin !~ '^\d{4,5}$' then
      return jsonb_build_object('ok',false,'error','PIN must be 4 digits');
    end if;
    if t.employee_id is null then
      if coalesce(p_name,'') = '' or coalesce(p_role,'') = '' or p_pin is null then
        return jsonb_build_object('ok',false,'error','new account needs name, role and PIN');
      end if;
      insert into staff_accounts(employee_id, name, role, pin, is_active)
      values (p_employee_id, p_name, p_role, p_pin, coalesce(p_is_active, true));
      return jsonb_build_object('ok',true,'created',true);
    end if;
    update staff_accounts set
      name = coalesce(nullif(p_name,''), name),
      role = coalesce(nullif(p_role,''), role),
      pin = coalesce(p_pin, pin),
      is_active = coalesce(p_is_active, is_active)
    where employee_id = p_employee_id;
    return jsonb_build_object('ok',true,'created',false);
  elsif p_action = 'wh_temp' then
    if t.employee_id is null then
      if coalesce(p_name,'') = '' then return jsonb_build_object('ok',false,'error','name required'); end if;
      insert into staff_accounts(employee_id, name, role, pin, is_active)
      values (p_employee_id, p_name, 'warehouse_employee', '60000', true);
      return jsonb_build_object('ok',true,'created',true);
    end if;
    if t.role not like 'warehouse%' then
      return jsonb_build_object('ok',false,'error','already has a '||t.role||' account');
    end if;
    update staff_accounts set is_active = true where employee_id = p_employee_id;
    return jsonb_build_object('ok',true,'created',false);
  end if;
  return jsonb_build_object('ok',false,'error','unknown action');
end $$;
revoke all on function public.staff_account_write(text,text,text,text,text,text,text,boolean) from public;
grant execute on function public.staff_account_write(text,text,text,text,text,text,text,boolean) to anon, authenticated;
