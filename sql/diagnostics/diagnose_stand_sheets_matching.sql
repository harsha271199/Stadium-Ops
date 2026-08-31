-- Run this to see the REAL cause of "only 30 items showing instead of 60."
-- Two possibilities, and this tells you which one it is:

-- 1. How many items does the catalog actually have for this stand?
select count(*) from stand_sheets where stand = 'Sun Devil Soccer Stadium';
-- If this comes back 30, the catalog itself only has 30 rows right now —
-- the 60-item load either didn't fully run, or got overwritten since.
-- If this comes back 60, the catalog is fine and the mismatch is #2 below.

-- 2. Does the exact stand name match between the two tables? (whitespace,
-- capitalization, anything subtly different would explain everything —
-- the app's matching used to require an exact string match)
select distinct stand, length(stand) as len from stand_sheets where stand ilike '%soccer%';
select distinct stand, length(stand) as len from inventory_entries where stand ilike '%soccer%';
-- If these two show DIFFERENT "len" values or anything visually different
-- for what looks like the same stand name, that's the real bug — a
-- trailing space or similar. The app now matches these case-insensitively
-- and trimmed, so this specific mismatch is already handled going
-- forward — but worth knowing for anywhere else stand names get typed in.
