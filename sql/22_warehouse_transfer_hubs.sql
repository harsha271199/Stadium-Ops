-- DFA Warehouse / MAS Warehouse — the two warehouse-to-warehouse transfer
-- endpoints (Desert Financial Arena and Mountain America Stadium). Not
-- concession stands (no roster, no checklists) — just two entries in
-- `stands` plus a shared stand_sheets item catalog so Warehouse Manager's
-- Create Transfer tool can send common bulk items between them and the
-- Transfers tab's "Download CSV" button has something real to export.
-- Safe to re-run.

-- WHERE NOT EXISTS instead of ON CONFLICT — `stands` predates the
-- versioned migrations in this folder and isn't guaranteed to have a
-- unique constraint on stand_name, so ON CONFLICT could error out here.
insert into stands (stand_name, venue, stand_type, is_main_stand, lead_access_for_all)
select v.stand_name, v.venue, v.stand_type, v.is_main_stand, v.lead_access_for_all
from (values
  ('DFA Warehouse', 'Desert Financial Arena', 'warehouse', true, false),
  ('MAS Warehouse', 'Mountain America Stadium', 'warehouse', true, false)
) as v(stand_name, venue, stand_type, is_main_stand, lead_access_for_all)
where not exists (select 1 from stands s where s.stand_name = v.stand_name);

-- Common items, exact names as already used elsewhere in stand_sheets
-- (matches sql/13_example_stand_sheet_60items.sql) — same catalog on
-- both warehouses so a transfer between them is picking from one
-- consistent item list, not two different ones.
--
-- Category is ALCOHOL/BEVERAGE/FOOD/SUPPLIES here, NOT the
-- Chargeable/Non-Chargeable/Supplies convention used in the concession
-- example sheet — mtRenderItems() (Create Transfer's item list) groups
-- by exactly those 4 buckets, falling back to a catch-all "OTHER" bucket
-- for anything else. Using the concession convention here would have
-- dumped every single item into OTHER instead of grouping properly.
delete from stand_sheets where stand in ('DFA Warehouse', 'MAS Warehouse');

insert into stand_sheets (stand, item_name, unit, pack, on_hand, restock, exp_start, chargeable, category)
select stand, item_name, unit, pack, on_hand, restock, exp_start, chargeable, category
from (values
  ('WATER - BTL 1 LITER SMART WATER', 'BOTTLE', '12-1LTR/CASE', 100, 0, 100, true, 'BEVERAGE'),
  ('BOTTLED 20OZ DASANI', 'BOTTLE', '24-20OZ/CASE', 150, 0, 150, true, 'BEVERAGE'),
  ('BOTTLED 20OZ POWERADE MTN BLAST', 'BOTTLE', '24 CASE', 50, 0, 50, true, 'BEVERAGE'),
  ('BEER - CAN 24OZ COORS LIGHT', 'CAN', 'CASE/12', 60, 0, 60, true, 'ALCOHOL'),
  ('BEER - CAN 24OZ DOS EQUIS', 'CAN', '12-24OZ/CASE', 40, 0, 40, true, 'ALCOHOL'),
  ('BEER - CAN 24OZ MILLER LITE', 'CAN', 'CASE/12', 40, 0, 40, true, 'ALCOHOL'),
  ('BEER - CAN 24OZ TOPO CHICO', 'CAN', 'CASE/12', 30, 0, 30, true, 'ALCOHOL'),
  ('CANDY SKITTLES', 'BAG', '10/36 CT', 20, 0, 20, true, 'FOOD'),
  ('CHIP JALAPENO KETTLE', 'BAG', 'CASE/64', 20, 0, 20, true, 'FOOD'),
  ('CHIP SEA SALT KETTLE', 'BAG', 'CASE 64/1.375', 20, 0, 20, true, 'FOOD'),
  ('BEEF - PITCHFORK DOG 5/1', 'EACH', '50/CASE', 80, 0, 80, true, 'FOOD'),
  ('PRETZELS', 'EACH', 'CASE/50', 30, 0, 30, true, 'FOOD'),
  ('SAUSAGE BRATWURST', 'EACH', 'CASE 2/5#', 20, 0, 20, true, 'FOOD'),
  ('CANDY SOUR PATCH KIDS', 'BOX', '12/3.5OZ', 20, 0, 20, true, 'FOOD'),
  ('BUN HOTDOG POTATO (8 EACH/BAG, 9 BAGS/RACK)', 'BAG', '12-8CT/CASE', 20, 0, 20, false, 'FOOD'),
  ('POPCORN - BAG ASU 85OZ', 'EACH', '500/CASE', 60, 0, 60, true, 'FOOD'),
  ('CUP LOYALTY 28OZ WHIRLEY', 'EACH', '100/CASE', 100, 0, 100, true, 'SUPPLIES'),
  ('CUP SOUVENIR SODA 32OZ CHURCHIL', 'EACH', '360CS/20LV/14 PER SLEEVE', 100, 0, 100, true, 'SUPPLIES'),
  ('NAPKIN DISPENSER', 'SLEEVE', 'SLEEVE', 40, 0, 40, false, 'SUPPLIES'),
  ('KETCHUP BAG DISPENSER', 'BAG', 'CASE/2 BAGS', 10, 0, 10, false, 'SUPPLIES'),
  ('MUSTARD BAG DISPENSER', 'BAG', 'CASE/2 BAGS', 10, 0, 10, false, 'SUPPLIES'),
  ('GLOVES NITRILE BLACK LARGE', 'EACH', 'CASE/10', 15, 0, 15, false, 'SUPPLIES'),
  ('CO2 35#', 'BIB', '5 GAL', 5, 0, 5, false, 'SUPPLIES')
) as items(item_name, unit, pack, on_hand, restock, exp_start, chargeable, category)
cross join (values ('DFA Warehouse'), ('MAS Warehouse')) as hubs(stand);
