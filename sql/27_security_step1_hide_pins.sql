-- Security step 1 (applied 2026-11-24): the public website key can no longer
-- read staff PINs. Sign-in checks PINs through staff_pin_match /
-- staff_accounts_safe (security definer), which never return the PIN.
-- Names, roles and IDs stay readable; INSERT/UPDATE are unchanged (Admin
-- still sets PINs).
revoke select on public.staff_accounts from anon, authenticated;
grant select (id, employee_id, name, role, is_active, created_at)
  on public.staff_accounts to anon, authenticated;
