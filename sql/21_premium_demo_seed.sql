-- Demo seed for the Premium department: 2 Premium Manager logins + today's
-- roster (matched from the 09/05/2026 ASU vs Morgan State Catering
-- Services Supervisor CSV, dated to today so it shows up in the demo).
-- Run 18_premium_department.sql, 19_premium_locations_seed.sql and
-- 20_premium_schedule.sql first. Safe to re-run.

-- ── 2 Premium Managers ──────────────────────────────────────────────
-- Both were Catering Services Supervisors on the source roster — pulled
-- out here as the demo's 2 Premium Managers rather than left as regular
-- scheduled workers. Login: last 5 of employee_id + this PIN.
insert into staff_accounts (employee_id, name, role, pin, is_active) values
  ('32448921', 'Larson, Amy', 'premium_manager', '4001', true),
  ('32310785', 'Pouessel, Emma', 'premium_manager', '4002', true)
on conflict (employee_id) do update set role = excluded.role, is_active = true;

-- ── Today's Premium roster ──────────────────────────────────────────
-- 3 roster rows had no Area/location at all (a floating lead and a
-- bartender with no assigned club) and are left out — this table is
-- location-based, so a worker needs a location to show up in it.
insert into premium_schedule (event_date, employee_id, worker_name, role_title, location_name, start_time, end_time, status) values
  (current_date, '32380232', 'Jacques, Courtnae', 'Catering Services Supervisor', 'Field Box', '12:00 PM', '11:00 PM', 'scheduled'),
  (current_date, '32308531', 'Shaheen, Ahmed', 'Student Worker', 'Field Box', '02:00 PM', '10:00 PM', 'scheduled'),
  (current_date, '32338858', 'Basavaraju, RashiRaju', 'Student Worker', 'Field Box', '02:00 PM', '10:00 PM', 'scheduled'),
  (current_date, '32454534', 'Pickles, Tara', 'Bartender', 'Field Box', '02:30 PM', '10:00 PM', 'scheduled'),

  (current_date, '32279306', 'Pellegrino, Joyce', 'Catering Services Supervisor', 'Hobbs Bar', '10:00 AM', '11:00 PM', 'scheduled'),
  (current_date, '32470470', 'Suthar, Viral', 'Student Worker', 'Hobbs Bar', '02:00 PM', '10:30 PM', 'scheduled'),
  (current_date, '32448933', 'LaGuardia, Donna', 'Bartender', 'Hobbs Bar', '02:30 PM', '11:00 PM', 'scheduled'),

  (current_date, '32277483', 'Ghorpade, Anamika', 'Catering Services Worker', 'West Club Coaches', '02:00 PM', '11:00 PM', 'scheduled'),
  (current_date, '32277497', 'Jaiswal, ArpitAnil', 'Catering Services Worker', 'West Club Coaches', '02:00 PM', '11:00 PM', 'scheduled'),
  (current_date, '32470489', 'Chaudhari, Ganesh', 'Catering Services Worker', 'West Club Coaches', '02:00 PM', '11:00 PM', 'scheduled'),
  (current_date, '32277579', 'Smith, Patrick', 'Bartender', 'West Club Coaches', '02:30 PM', '10:00 PM', 'scheduled'),
  (current_date, '32277581', 'Lujan, Isabella', 'Bartender', 'West Club Coaches', '02:30 PM', '10:00 PM', 'scheduled'),
  (current_date, '30289272', 'Diaz, Danny', 'Bartender', 'West Club Coaches', '02:30 PM', '10:00 PM', 'scheduled'),

  (current_date, '32470483', 'Kanchi, Likitha', 'Student Worker', 'West Clubs Founders', '02:30 PM', '11:00 PM', 'scheduled'),
  (current_date, '32470468', 'Singh, Anurag', 'Student Worker', 'West Clubs Founders', '02:30 PM', '11:00 PM', 'scheduled'),
  (current_date, '20227211', 'Fox, Lance', 'Bartender', 'West Clubs Founders', '02:30 PM', '11:00 PM', 'scheduled'),
  (current_date, '32359225', 'Powers, Ava', 'Catering Services Worker', 'West Clubs Founders', '03:00 PM', '10:00 PM', 'scheduled'),

  (current_date, '32277472', 'Sterling, Reagan', 'Catering Services Supervisor', 'West Clubs Legends', '12:00 PM', '11:00 PM', 'scheduled'),
  (current_date, '32446216', 'Yulwel, Tim', 'Catering Services Supervisor', 'West Clubs Legends', '12:00 PM', '11:00 PM', 'scheduled'),
  (current_date, '32461539', 'Sihombing, Siti', 'Catering Services Supervisor', 'West Clubs Legends', '12:00 PM', '11:00 PM', 'scheduled'),
  (current_date, '32308545', 'Narule, Harshada', 'Student Worker', 'West Clubs Legends', '02:00 PM', '11:00 PM', 'scheduled'),
  (current_date, '32470472', 'Gupta, Saakshi', 'Student Worker', 'West Clubs Legends', '02:00 PM', '11:00 PM', 'scheduled'),
  (current_date, '32470466', 'BoReqa, Abdullateef', 'Student Worker', 'West Clubs Legends', '02:00 PM', '11:00 PM', 'scheduled'),
  (current_date, '32277547', 'Felicetta, Adam', 'Bartender', 'West Clubs Legends', '02:30 PM', '10:00 PM', 'scheduled'),
  (current_date, '32277545', 'Kerr, Dan', 'Bartender', 'West Clubs Legends', '02:30 PM', '10:00 PM', 'scheduled'),

  (current_date, '32453412', 'Anaya, Chandler', 'Bartender', 'North Terrace', '02:30 PM', '10:30 PM', 'scheduled'),
  (current_date, '32470475', 'Karode, Saideep', 'Student Worker', 'North Terrace', '03:00 PM', '10:00 PM', 'scheduled'),
  (current_date, '32465855', 'Vijay, ShravanKrishna', 'Student Worker', 'North Terrace', '03:00 PM', '10:00 PM', 'scheduled'),

  (current_date, '32465843', 'Sreekumar, Shreyas', 'Student Worker (Cashier)', 'San Tan', '01:00 PM', '10:00 PM', 'scheduled'),
  (current_date, '32287839', 'EastmanGoupil, Heidi', 'Bartender', 'San Tan', '02:30 PM', '11:00 PM', 'scheduled'),
  (current_date, '32277455', 'Parker, Julie', 'Bartender', 'San Tan', '02:30 PM', '11:00 PM', 'scheduled'),
  (current_date, '32277582', 'Mach, Lisa', 'Bartender', 'San Tan', '02:30 PM', '11:00 PM', 'scheduled'),
  (current_date, '32281258', 'McCoun, Christopher', 'Bartender', 'San Tan', '02:30 PM', '10:00 PM', 'scheduled'),
  (current_date, '32277583', 'Titcomb, Vannessa', 'Bartender', 'San Tan', '02:30 PM', '11:00 PM', 'scheduled'),
  (current_date, '32277584', 'Carter, Mariah', 'Bartender', 'San Tan', '02:30 PM', '11:00 PM', 'scheduled'),
  (current_date, '32454532', 'McHenry, Lauren', 'Bartender', 'San Tan', '02:30 PM', '11:00 PM', 'scheduled'),
  (current_date, '32465856', 'Sinha, Ayushmann', 'Student Worker', 'San Tan', '03:00 PM', '10:00 PM', 'scheduled'),
  (current_date, '32454360', 'Sayyed, Fahim', 'Student Worker', 'San Tan', '03:00 PM', '10:00 PM', 'scheduled'),

  (current_date, '32283065', 'Rathwa, Aditya', 'Student Worker', 'South Loge', '02:30 PM', '10:00 PM', 'scheduled'),
  (current_date, '32347447', 'Parikh, Tanay', 'Student Worker', 'South Loge', '02:30 PM', '10:00 PM', 'scheduled'),
  (current_date, '32454533', 'Knott, Mark', 'Bartender', 'South Loge', '02:30 PM', '11:00 PM', 'scheduled'),
  (current_date, '32277456', 'Baker, Jalitta', 'Bartender', 'South Loge', '02:30 PM', '11:00 PM', 'scheduled'),

  (current_date, '32283067', 'Thakur, Aditya', 'Expo Captain', 'Suites 100', '10:00 AM', '12:00 AM', 'scheduled'),
  (current_date, '32277392', 'Strong, Bradley', 'Suite Attendant', 'Suites 100', '10:00 AM', '12:00 AM', 'scheduled'),
  (current_date, '32277390', 'Strong, Kadi', 'Suite Attendant', 'Suites 100', '10:00 AM', '12:00 AM', 'scheduled'),
  (current_date, '32277394', 'LinnemanWillis, Kimberly', 'Suite Attendant', 'Suites 100', '10:00 AM', '12:00 AM', 'scheduled'),
  (current_date, '32277393', 'Willis, Thomas', 'Suite Attendant', 'Suites 100', '10:00 AM', '12:00 AM', 'scheduled'),
  (current_date, '32277400', 'Halter, Emily', 'Suite Attendant', 'Suites 100', '10:00 AM', '12:00 AM', 'scheduled'),
  (current_date, '32305445', 'Vijayakumar, KirupalSujan', 'Runner-Busser', 'Suites 100', '12:00 PM', '12:00 AM', 'scheduled'),
  (current_date, '32470494', 'Venugopal, Ramchander', 'Runner-Busser', 'Suites 100', '12:00 PM', '12:00 AM', 'scheduled'),
  (current_date, '32306663', 'Jayan, Rithish', 'Runner-Busser', 'Suites 100', '12:00 PM', '12:00 AM', 'scheduled'),
  (current_date, '32347445', 'Vora, Khyati', 'Student Worker', 'Suites 100', '01:00 PM', '10:00 PM', 'scheduled'),
  (current_date, '32309343', 'Beesetti, GayathriVenkataSaiJyothi', 'Student Worker', 'Suites 100', '01:00 PM', '10:00 PM', 'scheduled'),
  (current_date, '32448934', 'Robinson, Aliyah', 'Bartender', 'Suites 100', '02:30 PM', '11:00 PM', 'scheduled'),
  (current_date, '32471283', 'Mahalungkar, Kartik', 'Student Worker', 'Suites 100', '03:00 PM', '10:00 PM', 'scheduled'),

  (current_date, '32274638', 'Shaik, Afshiya Roohi', 'Expo Captain', 'Suites 200', '10:00 AM', '12:00 AM', 'scheduled'),
  (current_date, '32277401', 'Cahoon, Anthony', 'Suite Attendant', 'Suites 200', '10:00 AM', '12:00 AM', 'scheduled'),
  (current_date, '32277397', 'Chango, Derrin', 'Suite Attendant', 'Suites 200', '10:00 AM', '12:00 AM', 'scheduled'),
  (current_date, '32277389', 'Harnish, Julie', 'Suite Attendant', 'Suites 200', '10:00 AM', '12:00 AM', 'scheduled'),
  (current_date, '32277396', 'Chango, Kimberly', 'Suite Attendant', 'Suites 200', '10:00 AM', '12:00 AM', 'scheduled'),
  (current_date, '32450226', 'Navarro, Chelsea', 'Suite Attendant', 'Suites 200', '10:00 AM', '12:00 AM', 'scheduled'),
  (current_date, '32347443', 'Challa, Prasannanjaneya', 'Runner-Busser', 'Suites 200', '11:00 AM', '12:00 AM', 'scheduled'),
  (current_date, '32338871', 'Jain, Nandini', 'Runner-Busser', 'Suites 200', '11:00 AM', '12:00 AM', 'scheduled'),
  (current_date, '32472731', 'Puthika, Geethanjali', 'Runner-Busser', 'Suites 200', '11:00 AM', '12:00 AM', 'scheduled'),
  (current_date, '32277548', 'Bernal, Alexander', 'Bartender', 'Suites 200', '02:30 PM', '11:00 PM', 'scheduled'),
  (current_date, '32452973', 'South, Alyssa', 'Bartender (Stadium Club)', 'Suites 200', '02:30 PM', '11:00 PM', 'scheduled'),
  (current_date, '32294619', 'Monde, Anmol', 'Catering Services Worker (Stadium Club)', 'Suites 200', '02:00 PM', '11:00 PM', 'scheduled'),
  (current_date, '32347473', 'Makhija, Akash', 'Catering Services Worker (Stadium Club)', 'Suites 200', '02:00 PM', '11:00 PM', 'scheduled'),

  (current_date, '32277477', 'Jain, Tanmay', 'Catering Services Worker', 'Suites - Press/Media', '10:00 AM', '09:00 PM', 'scheduled'),

  (current_date, '32465853', 'Karunanidhi, Ghowarthan', 'Student Worker', 'Suites 300', '02:00 PM', '11:00 PM', 'scheduled'),
  (current_date, '32289571', 'Devorce, Deayjah', 'Suite Attendant', 'Suites 300', '10:00 AM', '12:00 AM', 'scheduled'),
  (current_date, '32277350', 'Vasquez, Emily', 'Suite Attendant', 'Suites 300', '10:00 AM', '12:00 AM', 'scheduled'),
  (current_date, '32283486', 'Teo, Lagrimusfern', 'Expo Captain', 'Suites 300', '10:00 AM', '12:00 PM', 'scheduled'),

  (current_date, '32470487', 'Thangirala, Joel', 'Student Worker', 'DFA Tailgate', '01:00 PM', '08:00 PM', 'scheduled'),
  (current_date, '32448926', 'Kobel, Desiray', 'Bartender', 'DFA Tailgate', '02:30 PM', '08:00 PM', 'scheduled'),
  (current_date, '32448935', 'Musick, Jeffrey', 'Bartender', 'DFA Tailgate', '02:30 PM', '08:00 PM', 'scheduled'),
  (current_date, '32448925', 'Jimenez, Joseph', 'Bartender', 'DFA Tailgate', '02:30 PM', '08:00 PM', 'scheduled'),
  (current_date, '32448927', 'Galati, Leslie', 'Bartender', 'DFA Tailgate', '02:30 PM', '08:00 PM', 'scheduled')
on conflict (event_date, employee_id) do update set
  worker_name = excluded.worker_name,
  role_title = excluded.role_title,
  location_name = excluded.location_name,
  start_time = excluded.start_time,
  end_time = excluded.end_time;
