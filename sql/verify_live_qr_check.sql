-- Run these to confirm the new live-database QR check has what it needs.
-- Nothing here ADDS data — these are checks only, to catch any gap
-- before relying on this in production.

-- 1. Does every stand have a real venue value? The fix checks this field
-- to confirm a scanned stand is actually current/active — a blank one
-- could slip through incorrectly.
select id, stand_name, venue
from stands
where venue is null or venue = '';
-- Expect: 0 rows. If anything shows up, that stand's QR would currently
-- be ACCEPTED by the new check (empty isn't flagged as "inactive"),
-- which may not be what you want. Fix by setting a real venue value.

-- 2. Confirm every genuinely active Mountain America Stadium stand has
-- the exact right venue string (used for filtering elsewhere in the app
-- too, so this should already be right, but worth confirming here):
select stand_name, venue
from stands
where stand_name ilike '%beer portable%'
   or stand_name ilike '%game day%'
order by stand_name;
-- Expect: venue = 'Mountain America Stadium' for all of these (not
-- blank, not misspelled, not the "- Inactive" variant unless genuinely
-- retired).

-- 3. Confirm the 19 stands from the recent migration are really there,
-- with a proper venue value (this is what the live check will actually
-- be querying against):
select stand_name, venue from stands where stand_name in (
  '202P Beer Portable','206P Beer Portable','207P Lemonade SC','208P BarS Sausage',
  '209P Beer Portable','220P Beer Portable','221B Fork Em BBQ','224P Venezia Brick Oven SC',
  '226P Chick-Fil-A','227P BarS Sausage','228P Fan Fuel Beverage MKT','229P BarS Sausage',
  '229P Beer Portable','229P Game Day','230P Beer Portable','230P Lemonade SC',
  '231P Beer Portable','234P Beer Portable','405P Lemonade SC'
) order by stand_name;
-- Expect: all 19 rows present, each with venue = 'Mountain America Stadium'.

-- 4. IMPORTANT — permissions check. The app reads `stands` using its
-- public/anon key, not a logged-in admin session. If Row Level Security
-- is enabled on this table with a restrictive policy, the live QR check
-- could silently get zero rows back even for a real stand. Run this in
-- the Supabase SQL editor to see current policies:
select schemaname, tablename, policyname, roles, cmd, qual
from pg_policies
where tablename = 'stands';
-- If RLS is enabled and there's no policy allowing SELECT for the
-- anon/public role, that's the one thing that WOULD break this fix
-- silently — send me what this returns if you're not sure.
