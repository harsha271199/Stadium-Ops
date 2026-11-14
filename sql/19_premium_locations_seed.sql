-- Seed data for premium_locations, matched against the 09/05/2026 ASU vs
-- Morgan State Catering Services Supervisor roster (Premium department).
-- Run 18_premium_department.sql first if you haven't already.
--
-- Notes from matching the roster:
-- - "West Clubs Legends" was staffed on the roster (3 supervisors, 3
--   student workers, 2 bartenders) but wasn't on the original 12-location
--   list — added here as its own location.
-- - "Stadium Club" appears in the roster both as an area inside the
--   Suites 200 shift and as its own separate event — folded into
--   Suites 200 rather than made a standalone location.
-- - San Tan appears in ReadyOn as several small counters (North Bar,
--   South Bar, Craft/Cocktail Bar, Carver, Supervisor, Cashier, Dessert
--   Cart) under one "Premium San Tan" shift — collapsed into a single
--   "San Tan" Premium location instead of tracking each counter
--   separately.
--
-- Safe to re-run — ON CONFLICT (name) skips anything already there.

insert into premium_locations (name, is_active) values
  ('DFA Tailgate', true),
  ('Field Box', true),
  ('Hobbs Bar', true),
  ('North Terrace', true),
  ('San Tan', true),
  ('South Loge', true),
  ('Suites 100', true),
  ('Suites - Press/Media', true),
  ('Suites 200', true),
  ('Suites 300', true),
  ('West Club Coaches', true),
  ('West Clubs Founders', true),
  ('West Clubs Legends', true)
on conflict (name) do nothing;
