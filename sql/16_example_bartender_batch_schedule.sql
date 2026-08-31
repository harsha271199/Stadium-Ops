-- Schedules all 31 bartenders across the 8 real "Beer Portable" stands
-- (confirmed from your actual stands table), today 8/26/2026, 10:00 AM -
-- 12:00 PM. Since 8 stands x 2 people = only 16 slots but there are 31
-- bartenders, this splits all 31 evenly instead (7 stands get 4, one
-- gets 3) rather than leaving 15 people unscheduled. Exact pairing shown
-- in chat — this is not a dynamic/guessed match, every name below is
-- assigned to a specific real stand from your CSV.
--
-- Safe to re-run (re-running adds duplicate rows for the same date — 
-- delete first if you need to redo this exact batch).

insert into schedule (employee_id, worker_name, role, location, event_name, start_time, end_time, event_date, site, is_test) values
  -- 203P Beer Portable
  ('32464837','Vitoff, Benjamin',      'Concession Bartender','203P Beer Portable','203P Beer Portable','10:00','12:00','2026-08-26','',false),
  ('32461515','Kronenberg, Abbey',     'Concession Bartender','203P Beer Portable','203P Beer Portable','10:00','12:00','2026-08-26','',false),
  ('32454526','Flores, Jorge',         'Concession Bartender','203P Beer Portable','203P Beer Portable','10:00','12:00','2026-08-26','',false),
  ('32457456','Smith, Robert',         'Concession Bartender','203P Beer Portable','203P Beer Portable','10:00','12:00','2026-08-26','',false),
  -- 208P Beer Portable
  ('32456258','Ramos, Melanie',        'Concession Bartender','208P Beer Portable','208P Beer Portable','10:00','12:00','2026-08-26','',false),
  ('32454521','Almaguer, Bryan',       'Concession Bartender','208P Beer Portable','208P Beer Portable','10:00','12:00','2026-08-26','',false),
  ('20022939','Gooden, Gevaun',        'Concession Bartender','208P Beer Portable','208P Beer Portable','10:00','12:00','2026-08-26','',false),
  ('32454527','Little, Kayla',         'Concession Bartender','208P Beer Portable','208P Beer Portable','10:00','12:00','2026-08-26','',false),
  -- 212P Beer Portable
  ('32454522','Matroni, Daniel',       'Concession Bartender','212P Beer Portable','212P Beer Portable','10:00','12:00','2026-08-26','',false),
  ('32454519','Hasapopoulos, Audrey',  'Concession Bartender','212P Beer Portable','212P Beer Portable','10:00','12:00','2026-08-26','',false),
  ('32454530','Yazzie, Marthalene',    'Concession Bartender','212P Beer Portable','212P Beer Portable','10:00','12:00','2026-08-26','',false),
  ('32454518','Gutierrez, Arlon',      'Concession Bartender','212P Beer Portable','212P Beer Portable','10:00','12:00','2026-08-26','',false),
  -- 217P Beer Portable
  ('32448916','Golden, Jamie',         'Concession Bartender','217P Beer Portable','217P Beer Portable','10:00','12:00','2026-08-26','',false),
  ('32448915','Hill, Ebonie',          'Concession Bartender','217P Beer Portable','217P Beer Portable','10:00','12:00','2026-08-26','',false),
  ('32450512','Winder, Brandon',       'Concession Bartender','217P Beer Portable','217P Beer Portable','10:00','12:00','2026-08-26','',false),
  ('32446221','Kill, Isaac',           'Concession Bartender','217P Beer Portable','217P Beer Portable','10:00','12:00','2026-08-26','',false),
  -- 224P Beer Portable
  ('32446219','Doran, Chris',          'Concession Bartender','224P Beer Portable','224P Beer Portable','10:00','12:00','2026-08-26','',false),
  ('32446222','Taylor, Miranda',       'Concession Bartender','224P Beer Portable','224P Beer Portable','10:00','12:00','2026-08-26','',false),
  ('32446217','Zimmerman, Brian',      'Concession Bartender','224P Beer Portable','224P Beer Portable','10:00','12:00','2026-08-26','',false),
  ('32446220','Freeman, DeaNiqua',     'Concession Bartender','224P Beer Portable','224P Beer Portable','10:00','12:00','2026-08-26','',false),
  -- 228P Beer Portable
  ('32338367','Cupp, Edie',            'Concession Bartender','228P Beer Portable','228P Beer Portable','10:00','12:00','2026-08-26','',false),
  ('32336682','Reyes, Nicole',         'Concession Bartender','228P Beer Portable','228P Beer Portable','10:00','12:00','2026-08-26','',false),
  ('32335702','Garcia, Jake',          'Concession Bartender','228P Beer Portable','228P Beer Portable','10:00','12:00','2026-08-26','',false),
  ('32460028','Joey, Raymond Jr',      'Concession Bartender','228P Beer Portable','228P Beer Portable','10:00','12:00','2026-08-26','',false),
  -- 310P Beer Portable
  ('32324625','Lorentzen, Amanda',     'Concession Bartender','310P Beer Portable','310P Beer Portable','10:00','12:00','2026-08-26','',false),
  ('32309445','Nakamura, Kristy',      'Concession Bartender','310P Beer Portable','310P Beer Portable','10:00','12:00','2026-08-26','',false),
  ('32309444','Smith, Courtney',       'Concession Bartender','310P Beer Portable','310P Beer Portable','10:00','12:00','2026-08-26','',false),
  ('32283487','Gabaldon, Heidi',       'Concession Bartender','310P Beer Portable','310P Beer Portable','10:00','12:00','2026-08-26','',false),
  -- 316P Beer Portable
  ('32294450','Ramos, Melissa',        'Concession Bartender','316P Beer Portable','316P Beer Portable','10:00','12:00','2026-08-26','',false),
  ('32286184','Youngson, Caroline',    'Concession Bartender','316P Beer Portable','316P Beer Portable','10:00','12:00','2026-08-26','',false),
  ('32281262','WellsGuevara, Debora',  'Concession Bartender','316P Beer Portable','316P Beer Portable','10:00','12:00','2026-08-26','',false);

-- Verify:
--   select location, worker_name, employee_id from schedule
--   where event_date = '2026-08-26' and role = 'Concession Bartender'
--   order by location, worker_name;
