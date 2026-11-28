-- UNDO for part B: give the public key direct write access to staff_accounts again.
grant insert, update, delete on public.staff_accounts to anon, authenticated;
