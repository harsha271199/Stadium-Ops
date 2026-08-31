-- Real Yellow Dog stand sheet for Sun Devil Soccer Stadium — SOCCER ASU vs LSU, 8/27/2026.
-- Transcribed from the 5-page pre-event stand sheet photo, 60 items exact.
-- This feeds Inventory Count, Request Stock, and Add Stock Myself all from the
-- same source (they all read from stand_sheets) -- one upload, all three screens correct.
--
-- Replaces whatever's currently on file for this stand. Safe to re-run.

delete from stand_sheets where stand = 'Sun Devil Soccer Stadium';

insert into stand_sheets (stand, item_name, unit, pack, on_hand, restock, exp_start, chargeable, category) values
  ('Sun Devil Soccer Stadium', 'WATER - BTL 1 LITER SMART WATER', 'BOTTLE', '12-1LTR/CASE', 142, 0, 142, true, 'Chargeable'),
  ('Sun Devil Soccer Stadium', 'BOTTLED 20OZ DASANI', 'BOTTLE', '24-20OZ/CASE', 378, 0, 378, true, 'Chargeable'),
  ('Sun Devil Soccer Stadium', 'BOTTLED 20OZ POWERADE MTN BLAST', 'BOTTLE', '24 CASE', 28, 0, 28, true, 'Chargeable'),
  ('Sun Devil Soccer Stadium', 'CUP SOUVENIR SODA 32OZ CHURCHIL', 'EACH', '360CS/20LV/14 PER SLEEVE', 150, 0, 150, true, 'Chargeable'),
  ('Sun Devil Soccer Stadium', 'CAN 19.2OZ DEVILS HALO AMBER', 'CAN', 'CASE/12', 8, 0, 8, true, 'Chargeable'),
  ('Sun Devil Soccer Stadium', 'BEER - CAN 24OZ COORS LIGHT', 'CAN', 'CASE/12', 25, 0, 25, true, 'Chargeable'),
  ('Sun Devil Soccer Stadium', 'BEER - CAN 24OZ DOS EQUIS', 'CAN', '12-24OZ/CASE', 23, 0, 23, true, 'Chargeable'),
  ('Sun Devil Soccer Stadium', 'BEER - CAN 24OZ MILLER LITE', 'CAN', 'CASE/12', 17, 0, 17, true, 'Chargeable'),
  ('Sun Devil Soccer Stadium', 'BEER - CAN 24OZ TOPO CHICO', 'CAN', 'CASE/12', 31, 0, 31, true, 'Chargeable'),
  ('Sun Devil Soccer Stadium', 'CANDY SKITTLES', 'BAG', '10/36 CT', 0, 0, 0, true, 'Chargeable'),
  ('Sun Devil Soccer Stadium', 'CHIP JALAPENO KETTLE', 'BAG', 'CASE/64', 0, 0, 0, true, 'Chargeable'),
  ('Sun Devil Soccer Stadium', 'CHIP SEA SALT KETTLE', 'BAG', 'CASE 64/1.375', 0, 0, 0, true, 'Chargeable'),
  ('Sun Devil Soccer Stadium', 'CHIP SMOKEHOUSE KETTLE', 'BAG', 'CASE 64/1.375', 0, 0, 0, true, 'Chargeable'),
  ('Sun Devil Soccer Stadium', 'BEEF - PITCHFORK DOG 5/1', 'EACH', '50/CASE', 96, 0, 96, true, 'Chargeable'),
  ('Sun Devil Soccer Stadium', 'PRETZELS', 'EACH', 'CASE/50', 0, 0, 0, true, 'Chargeable'),
  ('Sun Devil Soccer Stadium', 'SAUSAGE BRATWURST', 'EACH', 'CASE 2/5#', 15, 0, 15, true, 'Chargeable'),
  ('Sun Devil Soccer Stadium', 'WINE 12OZ CAN PINOT GRIGIO', 'CAN', '750 ML', 10, 0, 10, true, 'Chargeable'),
  ('Sun Devil Soccer Stadium', 'WINE CAN 12OZ HOT TO TROT', 'CAN', '750 ML', 0, 0, 0, true, 'Chargeable'),
  ('Sun Devil Soccer Stadium', 'CANDY SOUR PATCH KIDS', 'BOX', '12/3.5OZ', 29, 0, 29, true, 'Chargeable'),
  ('Sun Devil Soccer Stadium', 'CUP LOYALTY 28OZ WHIRLEY', 'EACH', '100/CASE', 119, 0, 119, true, 'Chargeable'),
  ('Sun Devil Soccer Stadium', 'BEER - CAN 24OZ SIMPLY SPIKED BOLD LEMONADE', 'CAN', '12-24OZ/CASE', 12, 0, 12, true, 'Chargeable'),
  ('Sun Devil Soccer Stadium', 'CUP CHEESE DIP', 'EACH', 'CASE/30/3.625', 124, 0, 124, true, 'Chargeable'),
  ('Sun Devil Soccer Stadium', 'BOTTLED 20OZ POWERADE FRUIT', 'BOTTLE', 'BOTTLED', 17, 0, 17, true, 'Chargeable'),
  ('Sun Devil Soccer Stadium', 'BREAD - PRETZEL SOFT BAVARIAN 7OZ', 'EACH', '40/CASE', 56, 0, 56, true, 'Chargeable'),
  ('Sun Devil Soccer Stadium', 'BUCKET 160OZ CHURCHILL', 'EACH', 'CASE/100', 93, 0, 93, true, 'Chargeable'),
  ('Sun Devil Soccer Stadium', 'CANDY - LEMONADE 12OZ FROZEN', 'EACH', '12-12OZ/CASE', 62, 0, 62, true, 'Chargeable'),
  ('Sun Devil Soccer Stadium', 'CANDY - M&M PEANUT 3.1OZ', 'EACH', '12-3.1OZ/BOX', 0, 0, 0, true, 'Chargeable'),
  ('Sun Devil Soccer Stadium', 'SUPPLIES - CUP 24OZ PLASTIC CLR (SMALL SODA)', 'EACH', '12-60CT/CASE', 566, 0, 566, true, 'Chargeable'),
  ('Sun Devil Soccer Stadium', 'CANDY - M&M PLAIN 3.1OZ', 'EACH', '12-3.1OZ/BOX', 0, 0, 0, true, 'Chargeable'),
  ('Sun Devil Soccer Stadium', 'POPCORN - BAG ASU 85OZ', 'EACH', '500/CASE', 121, 0, 121, true, 'Chargeable'),
  ('Sun Devil Soccer Stadium', 'BIB COKE 5 GAL', 'BIB', '5 GAL', 0.5, 0, 0.5, false, 'Non-Chargeable'),
  ('Sun Devil Soccer Stadium', 'BIB DIET COKE 5 GAL', 'BIB', '5 GAL', 0, 0, 0, false, 'Non-Chargeable'),
  ('Sun Devil Soccer Stadium', 'BIB COKE ZERO 2.5 GAL', 'BIB', '5 GAL', 0.25, 0, 0.25, false, 'Non-Chargeable'),
  ('Sun Devil Soccer Stadium', 'BIB SPRITE 5 GAL', 'BIB', '5 GAL', 0.5, 0, 0.5, false, 'Non-Chargeable'),
  ('Sun Devil Soccer Stadium', 'BIB DR PEPPER 5 GAL', 'BIB', '5 GAL', 0.5, 0, 0.5, false, 'Non-Chargeable'),
  ('Sun Devil Soccer Stadium', 'BIB LEMONADE 2.5 GAL', 'BIB', '5 GAL', 0.25, 0, 0.25, false, 'Non-Chargeable'),
  ('Sun Devil Soccer Stadium', 'CHIPS TORTILLA NACHO BULK 8/16OZ', 'BAG', '8/16OZ', 13, 0, 13, false, 'Non-Chargeable'),
  ('Sun Devil Soccer Stadium', 'CO2 35#', 'BIB', '5 GAL', 0, 0, 0, false, 'Supplies'),
  ('Sun Devil Soccer Stadium', 'KETCHUP BAG DISPENSER', 'BAG', 'CASE/2 BAGS', 1, 0, 1, false, 'Non-Chargeable'),
  ('Sun Devil Soccer Stadium', 'MUSTARD BAG DISPENSER', 'BAG', 'CASE/2 BAGS', 1, 0, 1, false, 'Non-Chargeable'),
  ('Sun Devil Soccer Stadium', 'NAPKIN DISPENSER', 'SLEEVE', 'SLEEVE', 22, 0, 22, false, 'Non-Chargeable'),
  ('Sun Devil Soccer Stadium', 'DRY - PEPPER JALAPENO SLICED', 'GALLON', '4-1GAL/CASE', 3.5, 0, 3.5, false, 'Non-Chargeable'),
  ('Sun Devil Soccer Stadium', 'RELISH BAG DISPENSER', 'BAG', 'CASE/2 BAGS', 1, 0, 1, false, 'Non-Chargeable'),
  ('Sun Devil Soccer Stadium', 'BUN HOTDOG POTATO (8 EACH/BAG, 9 BAGS/RACK)', 'BAG', '12-8CT/CASE', 13, 0, 13, false, 'Non-Chargeable'),
  ('Sun Devil Soccer Stadium', 'WATER - NIAGRA 16.9OZ EMPLOYEE', 'CASE', '40/CASE', 1.5, 0, 1.5, false, 'Non-Chargeable'),
  ('Sun Devil Soccer Stadium', 'SOAP HAND FOAM ECOLAB', 'EACH', '6/Case', 2, 0, 2, false, 'Supplies'),
  ('Sun Devil Soccer Stadium', 'GLOVES NITRILE BLACK LARGE', 'EACH', 'CASE/10', 10, 0, 10, false, 'Supplies'),
  ('Sun Devil Soccer Stadium', 'GLOVES NITRILE BLACK MED', 'EACH', 'CASE/10', 2, 0, 2, false, 'Supplies'),
  ('Sun Devil Soccer Stadium', 'GLOVES NITRILE BLACK XL', 'EACH', 'CASE/10', 9, 0, 9, false, 'Supplies'),
  ('Sun Devil Soccer Stadium', 'BAG - PRETZEL 6.69X7.09', 'CASE', '400/CASE', 1, 0, 1, false, 'Non-Chargeable'),
  ('Sun Devil Soccer Stadium', 'GLOVES - NITRLIE FOOD SERVICE POWDER FREE SMALL', 'EACH', 'SMALL GLOVES', 2, 0, 2, false, 'Supplies'),
  ('Sun Devil Soccer Stadium', 'JANITORIAL - LINER REPRO 38X58 2ML', 'CASE', '75-60CT/CASE', 1, 0, 1, false, 'Supplies'),
  ('Sun Devil Soccer Stadium', 'JANITORIAL - LINER ROLL COMPOST 34X48 30 GAL', 'ROLL', '1/ROLL', 6, 0, 6, false, 'Supplies'),
  ('Sun Devil Soccer Stadium', 'JANITORIAL - TOWEL MULTIFOLD 16CT/CS', 'PACK', '16/CASE', 0, 0, 0, false, 'Supplies'),
  ('Sun Devil Soccer Stadium', 'JANITORIAL - TOWEL ROLL NON-PERF 7.75 NAT', 'ROLL', '6/CASE', 2, 0, 2, false, 'Supplies'),
  ('Sun Devil Soccer Stadium', 'JANITORIAL - TOWEL WIPER WT/RD 13X24 MD DRY', 'CASE', '1/CS', 1.5, 0, 1.5, false, 'Supplies'),
  ('Sun Devil Soccer Stadium', 'SUPPLIES - DEPOSIT 35LB CO2', 'BOTTLE', '1/TANK', 1, 0, 1, false, 'Supplies'),
  ('Sun Devil Soccer Stadium', 'SUPPLIES - GLOVE NITRILE BLK SMALL', 'BOX', '10-100CT/CASE', 0, 0, 0, false, 'Supplies'),
  ('Sun Devil Soccer Stadium', 'SUPPLIES - KNIFE PLAS COMPST PLANTW MED6', 'CASE', '1-1000EA/CASE', 0, 0, 0, false, 'Supplies'),
  ('Sun Devil Soccer Stadium', '20 # CO2', 'EACH', '20# CO2', 0, 0, 0, false, 'Supplies');

-- Verify:
--   select item_name, on_hand, exp_start, chargeable, category from stand_sheets
--   where stand = 'Sun Devil Soccer Stadium' order by category, item_name;
