-- The employee_directory table is already created and seeded with the
-- 168 people found in your existing schedule history. This is how you
-- load your FULL ReadyOn roster into it — everyone who could ever show
-- up as a walk-in, not just people already scheduled.

-- ============ HOW TO LOAD YOUR FULL ROSTER ============
-- Export the full employee list from ReadyOn, then either:
--
-- OPTION A (easiest for a big list): use Supabase's Table Editor →
-- employee_directory → "Import data from CSV". Your CSV needs columns
-- named exactly: employee_id, full_name, role
-- Name format should match how it appears everywhere else in the app:
-- "Last, First"
--
-- OPTION B: paste the values directly, like this:

insert into employee_directory (employee_id, full_name, role) values
  ('32282617', 'Chawla, Goyal', 'Concession Stand Lead'),
  ('32282630', 'Skinner, Steven', 'Concessions Supervisor')
  -- ... add the rest of your roster here, one line each
on conflict (employee_id) do update
  set full_name = excluded.full_name,
      role      = excluded.role,
      updated_at = now();
-- ON CONFLICT means this is safe to re-run and safe to use for updates —
-- re-importing an updated ReadyOn export will refresh names/roles rather
-- than erroring out or creating duplicates.


-- ============ USEFUL MAINTENANCE QUERIES ============

-- How many people are loaded right now:
--   select count(*) from employee_directory where is_active = true;

-- Find someone (same search the app's walk-in type-ahead uses):
--   select employee_id, full_name, role from employee_directory
--   where full_name ilike '%smith%' and is_active = true;

-- Mark someone inactive (leavers) rather than deleting — keeps their
-- historical attendance/schedule records intact and meaningful:
--   update employee_directory set is_active = false, updated_at = now()
--   where employee_id = '32282617';

-- Refresh the directory from any NEW schedule uploads (catches anyone
-- scheduled since the last ReadyOn import). Safe to run any time:
insert into employee_directory (employee_id, full_name, role)
select distinct on (employee_id) employee_id, worker_name, role
from schedule
where employee_id is not null and worker_name is not null
order by employee_id, event_date desc
on conflict (employee_id) do nothing;
