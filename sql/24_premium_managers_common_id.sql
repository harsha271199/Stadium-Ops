-- 2 more Premium Manager logins, using the new shared "70000" Premium
-- common ID (see the PREMIUM COMMON LOGIN branch in api('login') in
-- index.html) — same convenience as Warehouse's shared 60000 ID: sign in
-- with ID 70000 + your last name, nothing to memorize per person.
-- A 4-digit PIN is still set as a fallback (works with the regular last-5
-- ID + PIN flow too). Safe to re-run.

insert into staff_accounts (employee_id, name, role, pin, is_active) values
  ('170000', 'Hernandez, Nestor', 'premium_manager', '7001', true),
  ('270000', 'Crnjac, Natasha', 'premium_manager', '7002', true)
on conflict (employee_id) do update set role = excluded.role, is_active = true;
