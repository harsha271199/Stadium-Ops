-- Fixes the already-submitted 8/27 Count Out that landed on 8/28 instead,
-- because it was entered after midnight before this bug was fixed in the
-- app. This is a one-time correction for existing data — new submissions
-- after this deploy will be attributed correctly automatically.
--
-- Run the SELECT first to see exactly what will change before running
-- the UPDATE.

-- 1. See what's there right now:
select id, stand, phase, entry_date, created_at, submitted_by
from inventory_entries
where stand = 'Sun Devil Soccer Stadium'
  and entry_date = '2026-08-28'
  and created_at < '2026-08-28T06:00:00-07:00'
order by created_at;

-- 2. If that looks right (a Count Out submitted in the early hours,
-- clearly meant for the 8/27 game), fix it:
update inventory_entries
set entry_date = '2026-08-27'
where stand = 'Sun Devil Soccer Stadium'
  and entry_date = '2026-08-28'
  and created_at < '2026-08-28T06:00:00-07:00';

-- Same check/fix for checklists, if a Closing checklist has the same
-- issue for the same stand/night:
select id, stand, phase, entry_date, created_at, submitted_by
from checklists
where stand = 'Sun Devil Soccer Stadium'
  and entry_date = '2026-08-28'
  and created_at < '2026-08-28T06:00:00-07:00'
order by created_at;

update checklists
set entry_date = '2026-08-27'
where stand = 'Sun Devil Soccer Stadium'
  and entry_date = '2026-08-28'
  and created_at < '2026-08-28T06:00:00-07:00';
