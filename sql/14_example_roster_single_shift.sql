-- Today's Soccer Stadium roster (SOCCER 8/27), 5:00 PM - 9:00 PM.
-- 5 people: 3 student workers, 1 stand lead, 1 supervisor — all at
-- "Sun Devil Soccer Stadium" (the roster has no separate stand-by-stand
-- breakdown, everyone's under one site).
--
-- Delete-then-insert for just these 5 people/today, so this is safe to
-- re-run if the roster gets updated later today.

delete from schedule where employee_id in
  ('32347454','32338850','32308579','32282617','32282630')
  and event_date = '2026-08-27';

insert into schedule (employee_id, worker_name, role, location, event_name, start_time, end_time, event_date, site, is_test) values
  ('32347454', 'Sharma, Simran',            'Student Worker - Food Service or Catering', 'Sun Devil Soccer Stadium', 'SOCCER 8/27', '17:00', '21:00', '2026-08-27', 'Sun Devil Soccer Stadium', false),
  ('32338850', 'Kothari, Dhruv',             'Student Worker - Food Service or Catering', 'Sun Devil Soccer Stadium', 'SOCCER 8/27', '17:00', '21:00', '2026-08-27', 'Sun Devil Soccer Stadium', false),
  ('32308579', 'Devarajegowda, Rajashree',   'Student Worker - Food Service or Catering', 'Sun Devil Soccer Stadium', 'SOCCER 8/27', '17:00', '21:00', '2026-08-27', 'Sun Devil Soccer Stadium', false),
  ('32282617', 'Chawla, Goyal',              'Concession Stand Lead',                     'Sun Devil Soccer Stadium', 'SOCCER 8/27', '17:00', '21:00', '2026-08-27', 'Sun Devil Soccer Stadium', false),
  ('32282630', 'Skinner, Steven',            'Concessions Supervisor',                    'Sun Devil Soccer Stadium', 'SOCCER 8/27', '17:00', '21:00', '2026-08-27', 'Sun Devil Soccer Stadium', false);

-- Verify:
--   select worker_name, role, employee_id from schedule
--   where event_date = '2026-08-27' and site = 'Sun Devil Soccer Stadium'
--   order by role, worker_name;
