-- 20 new Support Manager accounts — shared login code 90000 + real last
-- name, same pattern as the existing 8. IDs are 8 digits ending in 90000,
-- prefixed 010-029 to stay unique and out of range of any real staff ID.
--
-- These show up ONLY as 'Manager' anywhere in the app (requests, feedback
-- records, etc.) -- the support_manager tier is purely a backend access
-- restriction (Overview only: Roster/Stock/IT/Live), never shown as a label.
--
-- Safe to re-run.

insert into staff_accounts (employee_id, name, role, pin, is_active) values
  ('01090000', 'Maldonado, Cristina', 'support_manager', '0000', true),
  ('01190000', 'O''Neill, Bevin', 'support_manager', '0000', true),
  ('01290000', 'Strauss, Paul', 'support_manager', '0000', true),
  ('01390000', 'Zuniga, Fernanda', 'support_manager', '0000', true),
  ('01490000', 'Velez, Alma', 'support_manager', '0000', true),
  ('01590000', 'David, Kirsten', 'support_manager', '0000', true),
  ('01690000', 'Thompson, Jake', 'support_manager', '0000', true),
  ('01790000', 'Carlson, Shawn', 'support_manager', '0000', true),
  ('01890000', 'Vega, Matthew', 'support_manager', '0000', true),
  ('01990000', 'Johnson, Martin', 'support_manager', '0000', true),
  ('02090000', 'Grinnell, Aaron', 'support_manager', '0000', true),
  ('02190000', 'Ortego, Scott', 'support_manager', '0000', true),
  ('02290000', 'Cullen, Jonathan', 'support_manager', '0000', true),
  ('02390000', 'Johnson, Symia', 'support_manager', '0000', true),
  ('02490000', 'Jones, Ronald', 'support_manager', '0000', true),
  ('02590000', 'Wright, Izell', 'support_manager', '0000', true),
  ('02690000', 'Berns, Richard', 'support_manager', '0000', true),
  ('02790000', 'Spencer, Jamison', 'support_manager', '0000', true),
  ('02890000', 'Bentz, Cooper', 'support_manager', '0000', true),
  ('02990000', 'Yiannopoulos, Nektaria', 'support_manager', '0000', true);

-- Verify:
--   select employee_id, name, role from staff_accounts
--   where employee_id like '0__90000' order by name;
