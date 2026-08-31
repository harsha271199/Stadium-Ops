-- Hard reset for the 8 manager accounts — clears out ANY existing row for
-- these specific employee IDs first (regardless of what role or PIN it
-- had before), then re-adds them fresh with pin '0000'. This is stronger
-- than the previous script, which only deleted by role='manager' — if one
-- of these IDs already existed under a different role or with a leftover
-- PIN, that old row would have survived and kept answering with its old
-- PIN instead of the new one.
--
-- No app redeploy needed — data change only, takes effect immediately.
-- Safe to re-run.

delete from staff_accounts where employee_id in
  ('90001','90002','90003','90004','90005','90006','90007','90008');

insert into staff_accounts (employee_id, name, role, pin, is_active) values
  ('90001', 'Gaona De Cazares, Yadzia', 'manager', '0000', true),
  ('90002', 'Byrd, Richard',            'manager', '0000', true),
  ('90003', 'St. John, David',          'manager', '0000', true),
  ('90004', 'Burke, Jordan',            'manager', '0000', true),
  ('90005', 'Andriyansa, Reno',         'manager', '0000', true),
  ('90006', 'Crnjac, Natasha',          'manager', '0000', true),
  ('90007', 'Hernandez, Nestor',        'manager', '0000', true),
  ('90008', 'Kagithoju, Harshavardhan', 'manager', '0000', true);

-- Confirm it worked — this should return exactly these 8 rows, all with
-- pin = '0000':
--
--   select employee_id, name, pin, is_active from staff_accounts
--   where employee_id in ('90001','90002','90003','90004','90005','90006','90007','90008')
--   order by employee_id;
--
-- Reminder: this PIN ('0000') is only for the old personal-PIN /manager
-- URL login path. The everyday login everyone should actually use is the
-- normal sign-in box with ID 97531 + their real last name — that path
-- doesn't check this pin column at all, only the shared code + name
-- match, so it's unaffected either way.
