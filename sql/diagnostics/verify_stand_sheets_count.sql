-- Run this to confirm, independently of anything the app tells you,
-- exactly how many items each stand's catalog has. Request Stock and
-- Inventory Count both pull from this exact same table (stand_sheets) —
-- there is no separate copy for either feature, so if this shows 60,
-- both screens are working from the same 60 items, in the same order
-- (order by id).

select stand, count(*) as item_count
from stand_sheets
group by stand
order by stand;

-- For one specific stand, see the actual items and their order:
select id, item_name, unit, pack, on_hand, exp_start
from stand_sheets
where stand = 'Sun Devil Soccer Stadium'
order by id;
-- Count the rows returned here — that's the exact number and exact
-- order both Request Stock and the Inventory report will use.
