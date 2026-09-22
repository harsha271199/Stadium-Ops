-- cart_inspections currently has ZERO access control — RLS isn't even
-- turned on. Every other table in your database has this enabled; this
-- one was missed. Fixing it requires two steps together, in order —
-- turning on RLS alone with no policy would lock the app out entirely.

alter table public.cart_inspections enable row level security;

-- Matches the same open-access pattern already used by every other
-- table in this app (anon key, full access) — safe, consistent with
-- how the rest of the app already works:
create policy "anon_all_cart_inspections" on public.cart_inspections
  for all to anon using (true) with check (true);

-- Verify:
--   select tablename, rowsecurity from pg_tables where tablename = 'cart_inspections';
--   select policyname, roles, cmd from pg_policies where tablename = 'cart_inspections';
