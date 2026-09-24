-- Completes today's Premium roster — adds the 4 people who were left out
-- of sql/21_premium_demo_seed.sql (Pouessel and Larson were pulled out as
-- manager candidates at the time; Brooks and Renguso had no Area/location
-- in the source CSV at all). Also normalizes Larson's and Pouessel's
-- Premium Manager logins onto the same shared "70000 + last name" scheme
-- as Hernandez and Crnjac, so all 4 managers work identically.
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
-- add her back as a scheduled worker even though she also has a manager
-- login now, since she genuinely had a shift that day.
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

-- Normalize Larson's and Pouessel's LOGIN accounts (staff_accounts,
-- separate from the roster rows above) onto the shared 70000 scheme.
-- Their real CSV IDs stay as-is in premium_schedule — this only changes
-- how they sign into the app.
update staff_accounts set employee_id = '370000' where employee_id = '32448921' and role = 'premium_manager';
update staff_accounts set employee_id = '470000' where employee_id = '32310785' and role = 'premium_manager';
