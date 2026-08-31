-- Full 8/30 roster, correctly matching the real CSV including
-- both shifts and the actual crew (not just Stand Lead/Supervisor,
-- which is all the earlier upload attempt actually contained).
-- Delete-then-insert for these exact people/date, safe to re-run.

delete from schedule
where employee_id in ('32282617','32282630','32308578','32347363','32448907','32454351','32454355','32461512')
  and event_date = '2026-08-30';

insert into schedule (employee_id, worker_name, role, location, event_name, start_time, end_time, event_date, site, is_test) values
  ('32282617', 'Chawla, Goyal', 'Concession Stand Lead', 'Sun Devil Soccer Stadium', 'SOCCER 8/30', '08:00', '13:00', '2026-08-30', 'Sun Devil Soccer Stadium', false),
  ('32282630', 'Skinner, Steven', 'Concessions Supervisor', 'Sun Devil Soccer Stadium', 'SOCCER 8/30', '08:00', '13:00', '2026-08-30', 'Sun Devil Soccer Stadium', false),
  ('32448907', 'Jackson, Marcus', 'Concession Stand Worker', 'Sun Devil Soccer Stadium', 'SOCCER 8/30', '08:00', '13:00', '2026-08-30', 'Sun Devil Soccer Stadium', false),
  ('32461512', 'Ervin, Brandon', 'Concession Stand Worker', 'Sun Devil Soccer Stadium', 'SOCCER 8/30', '08:00', '13:00', '2026-08-30', 'Sun Devil Soccer Stadium', false),
  ('32347363', 'Madasu, SriVignesh', 'Student Worker - Food Service or Catering', 'Sun Devil Soccer Stadium', 'SOCCER 8/30', '08:00', '13:00', '2026-08-30', 'Sun Devil Soccer Stadium', false),
  ('32308578', 'Thakkar, Krutarth', 'Student Worker - Food Service or Catering', 'Sun Devil Soccer Stadium', 'SOCCER 8/30', '17:00', '21:00', '2026-08-30', 'Sun Devil Soccer Stadium', false),
  ('32454351', 'Ulligeri, Swati', 'Student Worker - Food Service or Catering', 'Sun Devil Soccer Stadium', 'SOCCER 8/30', '17:00', '21:00', '2026-08-30', 'Sun Devil Soccer Stadium', false),
  ('32454355', 'Alla, GuruCharan', 'Student Worker - Food Service or Catering', 'Sun Devil Soccer Stadium', 'SOCCER 8/30', '17:00', '21:00', '2026-08-30', 'Sun Devil Soccer Stadium', false),
  ('32282630', 'Skinner, Steven', 'Concessions Supervisor', 'Sun Devil Soccer Stadium', 'SOCCER 8/30', '17:00', '21:00', '2026-08-30', 'Sun Devil Soccer Stadium', false),
  ('32282617', 'Chawla, Goyal', 'Concession Stand Lead', 'Sun Devil Soccer Stadium', 'SOCCER 8/30', '17:00', '21:00', '2026-08-30', 'Sun Devil Soccer Stadium', false);

-- Verify — should show 10 rows, 8 unique people:
--   select worker_name, role, start_time, end_time from schedule
--   where event_date = '2026-08-30' order by start_time, worker_name;
