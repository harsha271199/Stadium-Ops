-- Better than cleanup_bad_location_data.sql — that one fell back to
-- event_name ("SOCCER 8/30"), which STILL wouldn't match the real stand
-- name ("Sun Devil Soccer Stadium") that My Team, login, and everything
-- else actually filters by. The Site column was always captured
-- correctly even during the bug — this uses THAT instead, which is the
-- genuinely correct venue name for every affected row.
--
-- This is very likely why My Team only shows the stand lead right now:
-- their own row was probably entered correctly (direct SQL earlier), but
-- the REST of the roster came in through the buggy CSV upload and got
-- stuck with location = 'ASU Athletics' — which the My Team query
-- (filtered by the real stand name) simply never matches, so those
-- people never show up at all.

-- 1. See how many rows are actually affected:
select count(*) from schedule where location = 'ASU Athletics';

-- 2. Fix them, using each row's own (correctly captured) site value:
update schedule
set location = site
where location = 'ASU Athletics'
  and site is not null and site != '';

-- 3. Confirm it's clean:
select count(*) from schedule where location = 'ASU Athletics';
-- should be 0 now

-- 4. Confirm the roster for today actually shows everyone at the right stand:
select worker_name, role, location, start_time, end_time
from schedule
where location = 'Sun Devil Soccer Stadium' and event_date = '2026-08-30'
order by start_time, worker_name;
