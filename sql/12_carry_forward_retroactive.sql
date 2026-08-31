-- One-time catch-up: the carry-forward feature only applies going
-- forward from this deploy — it can't retroactively fix the 8/27 game's
-- Count Out, which already happened before this code existed. This pulls
-- that real closing count in now, so today's/next event's Exp Start
-- actually reflects what was really left on the shelf last time, not the
-- original static numbers from when the catalog was first loaded.
--
-- Only touches items that actually HAVE a real countOut value recorded —
-- never fabricates or guesses. Safe to re-run (uses the latest Count Out
-- entry per stand+item if there's more than one).

with latest_countout as (
  select distinct on (stand, key)
    stand,
    key as item_name,
    (value->>'countOut')::numeric as count_out
  from inventory_entries,
       jsonb_each(counts) as kv(key, value)
  where phase = 'Count Out'
    and value->>'countOut' is not null
    and value->>'countOut' != ''
  order by stand, key, created_at desc
)
update stand_sheets ss
set on_hand = lc.count_out,
    exp_start = lc.count_out
from latest_countout lc
where ss.stand = lc.stand
  and ss.item_name = lc.item_name;

-- Verify — compare against a specific stand's real 8/27 Count Out numbers:
--   select item_name, on_hand, exp_start from stand_sheets
--   where stand = 'Sun Devil Soccer Stadium' order by id;
