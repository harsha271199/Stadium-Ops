-- Completes today's Premium roster — adds the 4 people who were left out
-- of sql/21_premium_demo_seed.sql (Pouessel and Larson had been pulled
-- out as manager candidates early on; Brooks and Renguso had no
-- Area/location in the source CSV at all). Only Hernandez and Crnjac are
-- Premium Managers — Pouessel and Larson go in here as regular scheduled
-- workers, same as everyone else, nothing more.
--
-- Uses current_date, so run this ON THE DAY of the demo — that's what
-- makes it "today" rather than a fixed date.
-- Run 18/19/20/21/24 first if you haven't already.

-- A 14th Premium location for the 3 roster rows with no Area in the
-- source CSV (a floating lead, a floating supervisor, a floating
-- bartender — none tied to one specific club/suite).
insert into premium_locations (name, is_active)
select 'Premium — Floating', true
where not exists (select 1 from premium_locations where name = 'Premium — Floating');

-- Pouessel was the West Clubs Catering Supervisor on the source roster —
-- a regular scheduled worker, not a manager.
insert into premium_schedule (event_date, employee_id, worker_name, role_title, location_name, start_time, end_time, status)
select current_date, '32310785', 'Pouessel, Emma', 'Catering Services Supervisor', 'West Club Coaches', '12:00 PM', '10:00 PM', 'scheduled'
where not exists (select 1 from premium_schedule where event_date = current_date and employee_id = '32310785');

insert into premium_schedule (event_date, employee_id, worker_name, role_title, location_name, start_time, end_time, status)
select current_date, '32448921', 'Larson, Amy', 'Catering Services Supervisor', 'Premium — Floating', '12:00 PM', '10:00 PM', 'scheduled'
where not exists (select 1 from premium_schedule where event_date = current_date and employee_id = '32448921');

insert into premium_schedule (event_date, employee_id, worker_name, role_title, location_name, start_time, end_time, status)
select current_date, '32467832', 'Brooks, Phillip', 'Catering Services Worker Lead', 'Premium — Floating', '12:00 PM', '10:00 PM', 'scheduled'
where not exists (select 1 from premium_schedule where event_date = current_date and employee_id = '32467832');

insert into premium_schedule (event_date, employee_id, worker_name, role_title, location_name, start_time, end_time, status)
select current_date, '32281229', 'Renguso, Anthony', 'Bartender', 'Premium — Floating', '12:00 PM', '10:00 PM', 'scheduled'
where not exists (select 1 from premium_schedule where event_date = current_date and employee_id = '32281229');

-- If Larson or Pouessel were ever given a premium_manager login by an
-- earlier run of this file, remove it — they're roster workers only.
-- Hernandez and Crnjac (sql/24) remain the only 2 Premium Managers.
delete from staff_accounts where employee_id in ('370000','470000') and role = 'premium_manager';
