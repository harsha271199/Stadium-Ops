-- Promotes these 7 from Support Manager to full Manager tier.
-- They keep the exact same login (90000 + last name) and the exact same
-- employee_id — only the role field changes, which is what actually
-- controls access (Inventory + Records unlock, still no Admin).
--
-- Safe to re-run.

update staff_accounts set role = 'manager'
where employee_id in ('00190000','00290000','00390000','00490000','00590000','00690000','00790000');

-- Confirm it worked — all 7 should show role = 'manager':
--   select employee_id, name, role from staff_accounts
--   where employee_id in ('00190000','00290000','00390000','00490000','00590000','00690000','00790000')
--   order by name;
