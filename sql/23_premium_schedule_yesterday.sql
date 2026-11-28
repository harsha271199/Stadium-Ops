-- Same Premium roster as sql/21_premium_demo_seed.sql, dated to
-- YESTERDAY instead of today — so the demo can show the new date picker
-- on the Check-ins card actually looking back at a past game, not just
-- today's data. Shift times normalized to a simple 12:00 PM–10:00 PM
-- block for every row (the real CSV had varied times; one clean block is
-- easier to talk through in a demo). Safe to re-run.
-- Run 18/19/20/21 first if you haven't already.

insert into premium_schedule (event_date, employee_id, worker_name, role_title, location_name, start_time, end_time, status) values
  (current_date - 1, '32380232', 'Jacques, Courtnae', 'Catering Services Supervisor', 'Field Box', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32308531', 'Shaheen, Ahmed', 'Student Worker', 'Field Box', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32338858', 'Basavaraju, RashiRaju', 'Student Worker', 'Field Box', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32454534', 'Pickles, Tara', 'Bartender', 'Field Box', '12:00 PM', '10:00 PM', 'scheduled'),

  (current_date - 1, '32279306', 'Pellegrino, Joyce', 'Catering Services Supervisor', 'Hobbs Bar', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32470470', 'Suthar, Viral', 'Student Worker', 'Hobbs Bar', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32448933', 'LaGuardia, Donna', 'Bartender', 'Hobbs Bar', '12:00 PM', '10:00 PM', 'scheduled'),

  (current_date - 1, '32277483', 'Ghorpade, Anamika', 'Catering Services Worker', 'West Club Coaches', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32277497', 'Jaiswal, ArpitAnil', 'Catering Services Worker', 'West Club Coaches', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32470489', 'Chaudhari, Ganesh', 'Catering Services Worker', 'West Club Coaches', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32277579', 'Smith, Patrick', 'Bartender', 'West Club Coaches', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32277581', 'Lujan, Isabella', 'Bartender', 'West Club Coaches', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '30289272', 'Diaz, Danny', 'Bartender', 'West Club Coaches', '12:00 PM', '10:00 PM', 'scheduled'),

  (current_date - 1, '32470483', 'Kanchi, Likitha', 'Student Worker', 'West Clubs Founders', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32470468', 'Singh, Anurag', 'Student Worker', 'West Clubs Founders', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '20227211', 'Fox, Lance', 'Bartender', 'West Clubs Founders', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32359225', 'Powers, Ava', 'Catering Services Worker', 'West Clubs Founders', '12:00 PM', '10:00 PM', 'scheduled'),

  (current_date - 1, '32277472', 'Sterling, Reagan', 'Catering Services Supervisor', 'West Clubs Legends', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32446216', 'Yulwel, Tim', 'Catering Services Supervisor', 'West Clubs Legends', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32461539', 'Sihombing, Siti', 'Catering Services Supervisor', 'West Clubs Legends', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32308545', 'Narule, Harshada', 'Student Worker', 'West Clubs Legends', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32470472', 'Gupta, Saakshi', 'Student Worker', 'West Clubs Legends', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32470466', 'BoReqa, Abdullateef', 'Student Worker', 'West Clubs Legends', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32277547', 'Felicetta, Adam', 'Bartender', 'West Clubs Legends', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32277545', 'Kerr, Dan', 'Bartender', 'West Clubs Legends', '12:00 PM', '10:00 PM', 'scheduled'),

  (current_date - 1, '32453412', 'Anaya, Chandler', 'Bartender', 'North Terrace', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32470475', 'Karode, Saideep', 'Student Worker', 'North Terrace', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32465855', 'Vijay, ShravanKrishna', 'Student Worker', 'North Terrace', '12:00 PM', '10:00 PM', 'scheduled'),

  (current_date - 1, '32465843', 'Sreekumar, Shreyas', 'Student Worker (Cashier)', 'San Tan', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32287839', 'EastmanGoupil, Heidi', 'Bartender', 'San Tan', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32277455', 'Parker, Julie', 'Bartender', 'San Tan', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32277582', 'Mach, Lisa', 'Bartender', 'San Tan', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32281258', 'McCoun, Christopher', 'Bartender', 'San Tan', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32277583', 'Titcomb, Vannessa', 'Bartender', 'San Tan', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32277584', 'Carter, Mariah', 'Bartender', 'San Tan', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32454532', 'McHenry, Lauren', 'Bartender', 'San Tan', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32465856', 'Sinha, Ayushmann', 'Student Worker', 'San Tan', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32454360', 'Sayyed, Fahim', 'Student Worker', 'San Tan', '12:00 PM', '10:00 PM', 'scheduled'),

  (current_date - 1, '32283065', 'Rathwa, Aditya', 'Student Worker', 'South Loge', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32347447', 'Parikh, Tanay', 'Student Worker', 'South Loge', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32454533', 'Knott, Mark', 'Bartender', 'South Loge', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32277456', 'Baker, Jalitta', 'Bartender', 'South Loge', '12:00 PM', '10:00 PM', 'scheduled'),

  (current_date - 1, '32283067', 'Thakur, Aditya', 'Expo Captain', 'Suites 100', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32277392', 'Strong, Bradley', 'Suite Attendant', 'Suites 100', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32277390', 'Strong, Kadi', 'Suite Attendant', 'Suites 100', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32277394', 'LinnemanWillis, Kimberly', 'Suite Attendant', 'Suites 100', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32277393', 'Willis, Thomas', 'Suite Attendant', 'Suites 100', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32277400', 'Halter, Emily', 'Suite Attendant', 'Suites 100', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32305445', 'Vijayakumar, KirupalSujan', 'Runner-Busser', 'Suites 100', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32470494', 'Venugopal, Ramchander', 'Runner-Busser', 'Suites 100', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32306663', 'Jayan, Rithish', 'Runner-Busser', 'Suites 100', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32347445', 'Vora, Khyati', 'Student Worker', 'Suites 100', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32309343', 'Beesetti, GayathriVenkataSaiJyothi', 'Student Worker', 'Suites 100', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32448934', 'Robinson, Aliyah', 'Bartender', 'Suites 100', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32471283', 'Mahalungkar, Kartik', 'Student Worker', 'Suites 100', '12:00 PM', '10:00 PM', 'scheduled'),

  (current_date - 1, '32274638', 'Shaik, Afshiya Roohi', 'Expo Captain', 'Suites 200', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32277401', 'Cahoon, Anthony', 'Suite Attendant', 'Suites 200', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32277397', 'Chango, Derrin', 'Suite Attendant', 'Suites 200', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32277389', 'Harnish, Julie', 'Suite Attendant', 'Suites 200', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32277396', 'Chango, Kimberly', 'Suite Attendant', 'Suites 200', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32450226', 'Navarro, Chelsea', 'Suite Attendant', 'Suites 200', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32347443', 'Challa, Prasannanjaneya', 'Runner-Busser', 'Suites 200', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32338871', 'Jain, Nandini', 'Runner-Busser', 'Suites 200', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32472731', 'Puthika, Geethanjali', 'Runner-Busser', 'Suites 200', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32277548', 'Bernal, Alexander', 'Bartender', 'Suites 200', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32452973', 'South, Alyssa', 'Bartender (Stadium Club)', 'Suites 200', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32294619', 'Monde, Anmol', 'Catering Services Worker (Stadium Club)', 'Suites 200', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32347473', 'Makhija, Akash', 'Catering Services Worker (Stadium Club)', 'Suites 200', '12:00 PM', '10:00 PM', 'scheduled'),

  (current_date - 1, '32277477', 'Jain, Tanmay', 'Catering Services Worker', 'Suites - Press/Media', '12:00 PM', '10:00 PM', 'scheduled'),

  (current_date - 1, '32465853', 'Karunanidhi, Ghowarthan', 'Student Worker', 'Suites 300', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32289571', 'Devorce, Deayjah', 'Suite Attendant', 'Suites 300', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32277350', 'Vasquez, Emily', 'Suite Attendant', 'Suites 300', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32283486', 'Teo, Lagrimusfern', 'Expo Captain', 'Suites 300', '12:00 PM', '10:00 PM', 'scheduled'),

  (current_date - 1, '32470487', 'Thangirala, Joel', 'Student Worker', 'DFA Tailgate', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32448926', 'Kobel, Desiray', 'Bartender', 'DFA Tailgate', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32448935', 'Musick, Jeffrey', 'Bartender', 'DFA Tailgate', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32448925', 'Jimenez, Joseph', 'Bartender', 'DFA Tailgate', '12:00 PM', '10:00 PM', 'scheduled'),
  (current_date - 1, '32448927', 'Galati, Leslie', 'Bartender', 'DFA Tailgate', '12:00 PM', '10:00 PM', 'scheduled')
on conflict (event_date, employee_id) do update set
  worker_name = excluded.worker_name,
  role_title = excluded.role_title,
  location_name = excluded.location_name,
  start_time = excluded.start_time,
  end_time = excluded.end_time;
