-- 1. Is the toggle actually ON in the database right now?
select stand_name, lead_access_for_all
from stands
where stand_name = '203P Beer Portable';

-- Expect: lead_access_for_all = true
-- If it shows false (or the row is missing entirely), the toggle never
-- actually saved — tap it again in Admin, then re-run this query to
-- confirm it flips to true before testing login again.


-- 2. Does Benjamin's schedule row exist, with the exact right stand name?
select employee_id, worker_name, role, location, event_date
from schedule
where employee_id like '%64837'
order by event_date desc;

-- Expect: one row with location = '203P Beer Portable' exactly
-- (check for typos, extra spaces, or a different date than expected —
-- any mismatch here means the login lookup won't find what you expect).


-- 3. Turn every Beer Portable stand ON at once, no admin-screen clicking
-- needed — run this if you want to just force it and skip the UI:
update stands
set lead_access_for_all = true
where stand_name in (
  '203P Beer Portable',
  '208P Beer Portable',
  '212P Beer Portable',
  '217P Beer Portable',
  '224P Beer Portable',
  '228P Beer Portable',
  '310P Beer Portable',
  '316P Beer Portable'
);

-- Then confirm it took:
select stand_name, lead_access_for_all
from stands
where stand_name ilike 'Beer Portable%' or stand_name ilike '%Beer Portable%'
order by stand_name;
