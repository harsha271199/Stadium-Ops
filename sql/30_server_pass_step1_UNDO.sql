-- Undo sql/30_server_pass_step1.sql. The app keeps working without these
-- (it just stops getting a pass; sign-in is unchanged).
do $$
declare t text;
begin
  for t in select event_object_table from information_schema.triggers
            where trigger_schema = 'public' and trigger_name = 'zz_pass_audit' group by 1 loop
    execute format('drop trigger if exists zz_pass_audit on public.%I', t);
  end loop;
  if exists (select 1 from pg_extension where extname = 'pg_cron') then
    perform cron.unschedule(jobid) from cron.job where jobname = 'pass_cleanup';
  end if;
end $$;
drop function if exists public.pass_audit_trg();
drop function if exists public.current_pass();
drop function if exists public.end_pass(text);
drop function if exists public.renew_pass(text);
drop function if exists public.issue_pass(text, text, text, text, text, bigint, text);
drop function if exists public.pass_next_6am();
drop function if exists public.pass_name_ok(text, text);
drop function if exists public.pass_close(text, text);
drop function if exists public.pass_letters(text);
drop table if exists public.pass_audit;
drop table if exists public.pass_fail;
drop table if exists public.app_passes;
