-- Rewrite manager access — replaces whatever manager rows exist today
-- with exactly this list of 8. Anyone with manager access not on this
-- list loses it; anyone on this list gets it, whether or not they had
-- access before.
--
-- This only touches role='manager' rows — warehouse/tech accounts are
-- untouched.
--
-- No app redeploy needed for this — it's a data change only. Run this
-- directly in Supabase's SQL editor and it takes effect immediately.
--
-- After this runs, each person logs in on the normal sign-in screen
-- (same box as everyone else) using:
--   ID (last 5 digits):  97531   (the shared manager quick-code)
--   Last Name:           their own real last name, as listed below
--
-- The pin column (all set to '0000') is one shared value for everyone,
-- for now, per your request — it's only a fallback for the old personal-
-- PIN /manager URL path anyway; the quick login above doesn't check it
-- at all, only the shared code + last name.
--
-- Safe to re-run.

delete from staff_accounts where role = 'manager';

insert into staff_accounts (employee_id, name, role, pin, is_active) values
  ('90001', 'Gaona De Cazares, Yadzia', 'manager', '0000', true),
  ('90002', 'Byrd, Richard',            'manager', '0000', true),
  ('90003', 'St. John, David',          'manager', '0000', true),
  ('90004', 'Burke, Jordan',            'manager', '0000', true),
  ('90005', 'Andriyansa, Reno',         'manager', '0000', true),
  ('90006', 'Crnjac, Natasha',          'manager', '0000', true),
  ('90007', 'Hernandez, Nestor',        'manager', '0000', true),
  ('90008', 'Kagithoju, Harshavardhan', 'manager', '0000', true);

-- The employee_id values above (90001–90008) are placeholders, picked to
-- be outside the range of any real staff ID so they can't collide.
