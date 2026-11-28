-- Security step 2 (part B) — run ONLY after the build that uses
-- staff_account_write is live and Admin → Access save has been checked.
revoke insert, update, delete on public.staff_accounts from anon, authenticated;
