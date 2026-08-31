-- Splits the flat 'manager' role into three real tiers:
--   support_manager — game-day only, sees Stock/IT/Live, nothing else
--   manager         — full day-to-day access, minus Admin
--   admin           — everything, including Admin
--
-- All three log in exactly the same way — same shared quick code (97531)
-- + their own real last name, on the normal sign-in screen. The tier is
-- stored per-person here and just changes what they see once inside.
--
-- No app redeploy needed — data change only, takes effect immediately.
-- Safe to re-run.

update staff_accounts set role = 'support_manager'
where employee_id in ('90001','90002','90003','90004','90005','90006','90007');

update staff_accounts set role = 'admin'
where employee_id = '90008';

-- Confirm it worked — should show 7 support_manager rows and 1 admin row:
--
--   select employee_id, name, role from staff_accounts
--   where employee_id in ('90001','90002','90003','90004','90005','90006','90007','90008')
--   order by role, employee_id;
--
-- To promote a support manager to a full 'manager' or 'admin' later, or
-- demote one, just update their role the same way, e.g.:
--
--   update staff_accounts set role = 'manager' where employee_id = '90003';
