-- Gives every manager-tier person a real 8-digit employee_id ending in
-- 90000, matching how everyone else in this app already works — a real
-- ID stored in the database, matched by its last 5 digits at login. No
-- more hardcoded shared code living in the app's code — this is now
-- entirely data-driven, same as a worker's schedule row.
--
-- Login stays exactly the same from the person's side: ID field = 90000,
-- Last Name field = their real last name. Only where that "90000" lives
-- has changed — it's now the actual last 5 digits of a real ID in the
-- database, not a special-cased value inside the app itself.
--
-- The old personal-PIN /manager URL path is untouched by this — both
-- ways in still work side by side.
--
-- Safe to re-run.

update staff_accounts set employee_id = '00190000' where employee_id = '90001'; -- Gaona De Cazares, Yadzia
update staff_accounts set employee_id = '00290000' where employee_id = '90002'; -- Byrd, Richard
update staff_accounts set employee_id = '00390000' where employee_id = '90003'; -- St. John, David
update staff_accounts set employee_id = '00490000' where employee_id = '90004'; -- Burke, Jordan
update staff_accounts set employee_id = '00590000' where employee_id = '90005'; -- Andriyansa, Reno
update staff_accounts set employee_id = '00690000' where employee_id = '90006'; -- Crnjac, Natasha
update staff_accounts set employee_id = '00790000' where employee_id = '90007'; -- Hernandez, Nestor
update staff_accounts set employee_id = '00890000' where employee_id = '90008'; -- Kagithoju, Harshavardhan (Admin)

-- Confirm it worked — every row here should show an 8-digit ID ending
-- in 90000:
--
--   select employee_id, name, role from staff_accounts
--   where employee_id like '%90000'
--   order by role, employee_id;
--
-- To add a NEW manager later using this same easy-login pattern, just
-- give them a similarly formatted ID — the last 5 digits (90000) are
-- what actually matters for login, the first 3 just keep each ID unique:
--
--   insert into staff_accounts (employee_id, name, role, pin, is_active)
--   values ('00990000', 'Last, First', 'support_manager', '0000', true);
