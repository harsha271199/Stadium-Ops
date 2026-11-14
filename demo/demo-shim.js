/* Stadium Ops — DEMO MODE
 * Loaded before the app on the demo site only. Every call the app makes to
 * Supabase is answered here, in the browser, from a small fake database kept
 * in this browser's localStorage. Nothing is sent to the real database and no
 * real people are in it: stand and item names are real, every person is made
 * up. The demo data resets itself every day (or with the Reset button).
 * © 2026 Harshavardhan Kagithoju. All rights reserved.
 */
(function () {
  'use strict';
  var DB_KEY = 'stadium_ops_demo_db_v1';
  var AZ = function (ms) { return new Date((ms || Date.now()) - 7 * 3600e3); }; // Arizona, no DST
  var today = function () { return AZ().toISOString().slice(0, 10); };
  // Same "game day" rule as the app: before 6 AM still counts as last night.
  var demoDay = function () { return new Date(Date.now() - 13 * 3600e3).toISOString().slice(0, 10); };
  var nowIso = function () { return new Date().toISOString(); };

  // ---------- seed ----------
  function sheet(rows) { return rows.map(function (r, i) { return { item_name: r[0], unit: r[1], pack: r[2], exp_start: r[3], on_hand: r[3], restock: 0, category: r[4], chargeable: r[5], is_addon: !!r[6], sort_order: r[6] ? 1000 + i : i + 1, vendor: '', sku: '' }; }); }
  var P104 = [["BEER - CAN 24OZ COORS LIGHT","CAN","CASE/12",32,"CHARGEABLE","Chargeable"],["BEER - CAN 24OZ MILLER LITE","CAN","CASE/12",11,"CHARGEABLE","Chargeable"],["BEER - CAN 24OZ DOS EQUIS","CAN","12-24OZ/CASE",21,"CHARGEABLE","Chargeable"],["BEER - CAN 24OZ TOPO CHICO","CAN","CASE/12",27,"CHARGEABLE","Chargeable"],["WATER - BTL 1 LITER LIFE WATER","EACH","1L LIFE WATER",3,"CHARGEABLE","Chargeable"],["WINE - ARCHER ROOSE PINOT NOIR 250ML","EACH","4/250ML",6,"CHARGEABLE","Chargeable"],["WINE - ARCHER ROOSE SAUV BLANC 250ML","EACH","ARCH BLANC 250ML",8,"CHARGEABLE","Chargeable"],["WATER - NIAGRA 16.9OZ EMPLOYEE","CASE","40/CASE",0.1,"NON-CHARGEABLE","Non-Chargeable"],["JANITORIAL - TOWEL WIPER WT/RD 13X24 MD DRY","CASE","1/CS",1,"SUPPLIES","Supplies"],["GLOVES NITRILE BLACK MED","EACH","CASE/10",0,"SUPPLIES","Supplies"],["GLOVES NITRILE BLACK LARGE","EACH","CASE/10",1,"SUPPLIES","Supplies"]];
  var BEV = [["BEER - CAN 24OZ DOS EQUIS","CAN","12-24OZ/CASE",43,"CHARGEABLE","Chargeable"],["BEER - CAN 24OZ COORS LIGHT","CAN","CASE/12",91,"CHARGEABLE","Chargeable"],["BEER - CAN 24OZ MILLER LITE","CAN","CASE/12",41,"CHARGEABLE","Chargeable"],["BEER - CAN 24OZ TOPO CHICO","CAN","CASE/12",43,"CHARGEABLE","Chargeable"],["CAN 19.2OZ DEVILS HALO LAGER","EACH","",55,"CHARGEABLE","Chargeable"],["CANDY - M&M PEANUT 3.1OZ","EACH","12-3.1OZ/BOX",0,"CHARGEABLE","Chargeable"],["CHIP SEA SALT KETTLE","BAG","CASE 64/1.375",0,"CHARGEABLE","Chargeable"],["BOTTLED 20OZ GATORADE BLUE ZERO","EACH","20OZ GTRADE BL Z",45,"CHARGEABLE","Chargeable"],["BOTTLED 20OZ GATORADE RED","EACH","20OZ GTRADE RED",42,"CHARGEABLE","Chargeable"],["WATER - BOTTLED 20OZ AQUAFINA","EACH","20OZ AQUAFINA",184,"CHARGEABLE","Chargeable"],["WATER - BTL 1 LITER LIFE WATER","EACH","1L LIFE WATER",345,"CHARGEABLE","Chargeable"],["CAN 19.2OZ DEVILS HALO AMBER","CAN","CASE/12",49,"CHARGEABLE","Chargeable"],["BOTTLED SODA 20OZ PEPSI","EACH","20OZ PEPSI",41,"CHARGEABLE","Chargeable",true],["BOTTLED SODA 20OZ STARRY","EACH","20OZ STARRY",25,"CHARGEABLE","Chargeable",true]];
  var MAIN = [["SAUSAGE BRATWURST","EACH","CASE 2/5#",32,"CHARGEABLE","Chargeable"],["BREAD - PRETZEL SOFT BAVARIAN 7 OZ","EACH","40/CASE",77,"CHARGEABLE","Chargeable"],["CUP CHEESE DIP","EACH","CASE/30/3.625",97,"CHARGEABLE","Chargeable"],["BUCKET 160OZ CHURCHILL","EACH","CASE/100",78,"CHARGEABLE","Chargeable"],["POPCORN - BAG ASU 850Z","EACH","500/CASE",199,"CHARGEABLE","Chargeable"],["PEANUTS BAG 7 OZ","EACH","CASE/36-7OZ",24,"CHARGEABLE","Chargeable"],["CHIP JALAPENO KETTLE","BAG","CASE/64",13,"CHARGEABLE","Chargeable"],["CHIP SEA SALT KETTLE","BAG","CASE 64/1.375",17,"CHARGEABLE","Chargeable"],["BEER - CAN 24OZ COORS LIGHT","CAN","CASE/12",21,"CHARGEABLE","Chargeable"],["BEER - CAN 24OZ MILLER LITE","CAN","CASE/12",17,"CHARGEABLE","Chargeable"],["BEER - CAN 24OZ DOS EQUIS","CAN","12-24OZ/CASE",22,"CHARGEABLE","Chargeable"],["BEER - CAN 24OZ TOPO CHICO","CAN","CASE/12",20,"CHARGEABLE","Chargeable"],["CUP SOUVENIR SODA 32OZ CHURCHIL","EACH","360CS/20SLV/14 PER SLEEVE",398,"CHARGEABLE","Chargeable"],["CUP LOYALTY 28OZ WHIRLEY","EACH","100/CASE",19,"CHARGEABLE","Chargeable"],["BOTTLED 20OZ GATORADE BLUE ZERO","EACH","20OZ GTRADE BL Z",18,"CHARGEABLE","Chargeable"],["CANDY - MIKE AND IKE MEGA MIX","EACH","MIKE&IKE MEGA MX",35,"CHARGEABLE","Chargeable"],["PORK/BEEF 5X1 HOTDOG","EACH","PORK/BEEF 5X1",22,"CHARGEABLE","Chargeable"],["TRAY PAPER FOOD 3LB COMPOSTABLE","EACH","3LB BOAT",100,"CHARGEABLE","Chargeable"],["WATER - BOTTLED 20OZ AQUAFINA","EACH","20OZ AQUAFINA",71,"CHARGEABLE","Chargeable"],["WATER - BTL 1 LITER LIFE WATER","EACH","1L LIFE WATER",49,"CHARGEABLE","Chargeable"],["CHIPS TORTILLA NACHO BULK 8/16oz","BAG","8/16oz",8,"NON-CHARGEABLE","Non-Chargeable"],["KETCHUP BAG DISPENSER","BAG","CASE/2 BAGS",1,"NON-CHARGEABLE","Non-Chargeable"],["NAPKIN DISPENSER","SLEEVE","SLEEVE",2,"NON-CHARGEABLE","Non-Chargeable"],["BIB SODA PEPSI 5GAL","EACH","BIB 5GAL PEPSI",1,"NON-CHARGEABLE","Non-Chargeable"],["BUN HOTDOG POTATO (8 EACH/BAG, 9 BAGS/RACK)","BAG","12-8CT/CASE",24,"NON-CHARGEABLE","Non-Chargeable"],["SOAP HAND FOAM ECOLAB","EACH","6/Case",1,"SUPPLIES","Supplies"],["GLOVES NITRILE BLACK LARGE","EACH","CASE/10",2,"SUPPLIES","Supplies"],["SNO BLAST BLUE RASPBERRY","EACH","",4,"Chargeable","Chargeable",true],["BEEF - PITCHFORK DOG 5/1","EACH","50/CASE",19,"STAND SHEET","Chargeable",true]];
  var BURGER = [["PAPER - BOX FRENCH FRY","EACH","100/CASE",140,"CHARGEABLE","Chargeable"],["BEER - CAN 24OZ COORS LIGHT","CAN","CASE/12",131,"CHARGEABLE","Chargeable"],["BEER - CAN 24OZ DOS EQUIS","CAN","12-24OZ/CASE",187,"CHARGEABLE","Chargeable"],["BEER - CAN 24OZ MILLER LITE","CAN","CASE/12",145,"CHARGEABLE","Chargeable"],["BEER - CAN 24OZ TOPO CHICO","CAN","CASE/12",152,"CHARGEABLE","Chargeable"],["CAN 19.2OZ DEVILS HALO LAGER","EACH","",120,"CHARGEABLE","Chargeable"],["CUP SOUVENIR SODA 32OZ CHURCHIL","EACH","360CS/20SLV/14 PER SLEEVE",156,"CHARGEABLE","Chargeable"],["BEEF - BURGER PATTY 5.3OZ","EACH","BEEF PATTY 5.3OZ",340,"CHARGEABLE","Chargeable"],["BREAD - PRETZEL SOFT BAVARIAN 7 OZ","EACH","40/CASE",120,"CHARGEABLE","Chargeable"],["HONEY HOT 1OZ PORTION CUP","EACH","1OZ HOT HONEY PC",20,"CHARGEABLE","Chargeable"],["TRAY FOOD PAPER 2LB COMPOSTABLE","EACH","2LB BOAT",297,"CHARGEABLE","Chargeable"],["WATER - BOTTLED 20OZ AQUAFINA","EACH","20OZ AQUAFINA",117,"CHARGEABLE","Chargeable"],["BUN POTATO 4\" 12/8CT CS","CASE","12/8CT CS",20,"NON-CHARGEABLE","Non-Chargeable"],["CHEESE - CHEDDAR MILD SLICED","SLEEVE","8-1.25LB/CASE",2.5,"NON-CHARGEABLE","Non-Chargeable"],["FRIES 3/8 INCH","BAG","CASE/6 BAGS",259,"NON-CHARGEABLE","Non-Chargeable"],["FROZEN - CHICKEN TENDER COOKED ARAMARK","BAG","2/5 LB/CASE",42,"NON-CHARGEABLE","Non-Chargeable"],["SOAP HAND FOAM ECOLAB","EACH","6/Case",2,"SUPPLIES","Supplies"],["CANDY - MIKE AND IKE MEGA MIX","EACH","MIKE&IKE MEGA MX",15,"CHARGEABLE","Chargeable",true]];

  // Everyone below is made up. Login cheat sheet: see DEMO_LOGINS.
  var PEOPLE = [
    // stand, role, name, employee id
    ['DFA 111', 'Concessions Supervisor', 'Rivera, Sam', '90010001'],
    ['DFA 111', 'Concession Stand Lead', 'Lopez, Maya', '90010002'],
    ['DFA 111', 'Concession Stand Worker', 'Chen, Alex', '90010003'],
    ['DFA 111', 'Student Worker - Food Service or Catering', 'Patel, Riya', '90010004'],
    ['104P Beer Portable', 'Concession Bartender', 'Brooks, Jamie', '90010005'],
    ['DFA 143', 'Concession Stand Lead', 'Nguyen, Tara', '90010006'],
    ['DFA 143', 'Concession Stand Worker', 'Kim, Jordan', '90010007'],
    ['MKT Game Day Burger', 'Concession Stand Lead', 'Garcia, Luis', '90010008'],
    ['MKT Game Day Burger', 'Student Worker - Food Service or Catering', 'Singh, Arjun', '90010009']
  ];
  var DEMO_LOGINS = [
    ['Stand worker', 'Main sign-in', 'ID 10003 · last name Chen'],
    ['Student worker', 'Main sign-in', 'ID 10004 · last name Patel'],
    ['Stand Lead', 'Main sign-in', 'ID 10002 · last name Lopez'],
    ['Supervisor', 'Main sign-in', 'ID 10001 · last name Rivera'],
    ['Bartender (portable)', 'Main sign-in', 'ID 10005 · last name Brooks'],
    ['Manager', 'Main sign-in', 'ID 20002 · PIN 2222'],
    ['Support Manager', 'Main sign-in', 'ID 20003 · PIN 3333'],
    ['Warehouse Manager', 'Main sign-in', 'ID 20004 · PIN 4444'],
    ['Warehouse runner', 'Main sign-in', 'ID 20005 · PIN 5555'],
    ['Food Manager', 'Main sign-in', 'ID 20006 · PIN 6666'],
    ['Food Runner', 'Main sign-in', 'ID 20007 · PIN 7777'],
    ['IT', 'Main sign-in', 'ID 20008 · PIN 8888'],
    ['Premium Manager', 'Main sign-in', 'ID 70000 · last name Premium'],
    ['Suite Attendant (sells bottles)', 'Main sign-in', 'ID 30001 · last name Suite'],
    ['NPO Lead', 'NPO sign-in', 'Demo Boosters Club · PIN 1234 · name: Booster Lead'],
    ['NPO member', 'NPO sign-in', 'Demo Boosters Club · PIN 1234 · name: Booster One'],
    ['Admin', 'add /manager to the link', 'ID 20001 · PIN 1111']
  ];

  function seed() {
    var d = demoDay(), t = nowIso();
    var db = { _day: d, _id: 1000 };
    var id = function () { return ++db._id; };
    var V = 'Desert Financial Arena';
    db.stands = [['DFA 111', true, false], ['DFA 143', true, false], ['MKT Game Day Burger', true, false], ['BEV MKT', false, true], ['104P Beer Portable', false, true]]
      .map(function (s) { return { id: id(), stand_name: s[0], stand_type: 'concession', venue: V, is_main_stand: s[1], lead_access_for_all: s[2], created_at: t, operator: '', description: '' }; });
    db.stand_sheets = [];
    [['DFA 111', MAIN], ['DFA 143', MAIN], ['MKT Game Day Burger', BURGER], ['BEV MKT', BEV], ['104P Beer Portable', P104]].forEach(function (s) {
      sheet(s[1]).forEach(function (r) { r.id = id(); r.stand = s[0]; db.stand_sheets.push(r); });
    });
    db.schedule = PEOPLE.map(function (p) { return { id: id(), event_name: p[0] + ' Demo Basketball', event_date: d, site: 'DFA', start_time: '06:00', end_time: '23:59', role: p[1], worker_name: p[2], employee_id: p[3], work_schedule_type: 'Demo', location: p[0], is_test: false, created_at: t }; });
    var acct = function (eid, pin, name, role) { return { id: id(), employee_id: eid, pin: pin, name: name, role: role, is_active: true, created_at: t }; };
    db.staff_accounts = [acct('90020001', '1111', 'Admin, Demo', 'admin'), acct('90020002', '2222', 'Manager, Demo', 'manager'), acct('90020003', '3333', 'Support, Demo', 'support_manager'),
      acct('90020004', '4444', 'Warehouse, Demo', 'warehouse_manager'), acct('90020005', '5555', 'Runner, Demo', 'warehouse_employee'), acct('90020006', '6666', 'Kitchen, Demo', 'food_manager'),
      acct('90020007', '7777', 'Delivery, Demo', 'food_runner'), acct('90020008', '8888', 'Tech, Demo', 'tech'), acct('98770000', '9999', 'Premium, Demo', 'premium_manager')];
    db.kitchen_runner_assignments = [{ employee_id: '90020007', name: 'Delivery, Demo', role: 'food_runner', stands: db.stands.map(function (s) { return s.stand_name; }), is_active: true, updated_at: t }];
    db.game_day_assignments = [{ event_date: d, venue: V, employee_id: '90020005', name: 'Runner, Demo', role: 'warehouse_employee', team: 'warehouse', area_keys: [], direct_stands: db.stands.map(function (s) { return s.stand_name; }), backup_stands: [], notify_requests: true, source: 'manual', updated_at: t, updated_by: '' }];
    db.warehouse_roster = [{ id: id(), event_date: d, role: 'Warehouse Worker', name: 'Runner, Demo', employee_id: '90020005', phone: '', work_schedule_type: 'Demo', start_time: '06:00', end_time: '23:59', uploaded_at: t }];
    db.premium_locations = ['Premium Warehouse', 'Suites 200', 'Suites 300', 'Hobbs Bar'].map(function (n) { return { id: id(), name: n, is_active: true, created_at: t }; });
    db.premium_schedule = [['90030001', 'Suite, Demo', 'Suite Attendant', 'Suites 300'], ['90030002', 'Bar, Demo', 'Bartender', 'Hobbs Bar'], ['90030003', 'Busser, Demo', 'Runner-Busser', 'Suites 200']]
      .map(function (p) { return { id: id(), event_date: d, employee_id: p[0], worker_name: p[1], role_title: p[2], location_name: p[3], start_time: '04:00 PM', end_time: '10:00 PM', status: 'scheduled', is_walkin: false, updated_at: t }; });
    db.app_settings = [{ key: 'bottle_sell_access:' + d, value: '90030001' }, { key: 'liquor_items', value: JSON.stringify(['KIM CRAWFORD SAUVIGNON BLANC', 'CHATEAU STE. MICHELLE CABERNET SAUVIGNON', "TITO'S HANDMADE VODKA", 'GREY GOOSE VODKA']) }]
      .map(function (s) { s.updated_at = t; s.updated_by = 'demo'; return s; });
    db.liquor_bottles = [['1592101', 'KIM CRAWFORD SAUVIGNON BLANC', 'Premium Warehouse'], ['1592102', 'KIM CRAWFORD SAUVIGNON BLANC', 'Premium Warehouse'], ['1592103', 'CHATEAU STE. MICHELLE CABERNET SAUVIGNON', 'Suites 300'], ['1592104', "TITO'S HANDMADE VODKA", 'Hobbs Bar']]
      .map(function (b) { return { id: id(), sticker_no: b[0], roll_color: 'Pink', item_name: b[1], location: b[2], status: 'open', event_date: d, issued_at: t, issued_by: 'Premium, Demo', client_uuid: 'demo-' + b[0], updated_at: t }; });
    db.liquor_bottle_events = db.liquor_bottles.map(function (b) { return { id: id(), bottle_id: b.id, sticker_no: b.sticker_no, action: 'tag', item_name: b.item_name, location: b.location, who: 'Premium, Demo', at: t, client_uuid: b.client_uuid + '-ev' }; });
    var g = id();
    db.npo_groups = [{ id: g, group_name: 'Demo Boosters Club', pin: '1234', stand: 'BEV MKT', contact_name: 'Demo Contact', contact_phone: '', is_active: true, created_at: t }];
    db.npo_members = [['Booster, Lead', true], ['Booster, One', false], ['Booster, Two', false]].map(function (m) { return { id: id(), group_id: g, member_name: m[0], is_lead: m[1], is_active: true, notes: '', created_at: t }; });
    db.game_day_content = [{ event_date: d, venue_key: 'all', event_name: 'DEMO · ASU vs Example U', date_label: 'Demo game day', show_details: true, gates_open: '5:30 PM', start_time: '7:00 PM', est_attendance: '9,000', details_note: 'This is a demo with fake data.', show_meals: true, meals_text: 'Staff meal: hot dogs, salad, fruit', show_policy: true, policy_text: 'Smile, keep lines moving, ask your lead for help.', updated_at: t, updated_by: 'demo' }];
    return db;
  }

  // ---------- storage ----------
  var DB = null;
  function load() {
    try { DB = JSON.parse(localStorage.getItem(DB_KEY) || 'null'); } catch (e) { DB = null; }
    if (!DB || DB._day !== demoDay()) { DB = seed(); save(); }
  }
  function save() { try { localStorage.setItem(DB_KEY, JSON.stringify(DB)); } catch (e) {} }
  function table(n) { return DB[n] || (DB[n] = []); }

  // ---------- defaults (mirrors the real database) ----------
  var DEF = {
    attendance: { status: 'working', notes: '', entry_date: '@today' }, transfers: { status: 'pending', notes: '', game_date: '@today' }, transfer_items: { pack: '', note: '', source: 'manual', qty_requested: 0, qty_delivered: 0, delivered: false },
    stand_transfers: { status: 'pending', qty: 0 }, stock_ledger: { qty: 0, direction: 'in', note: '', game_date: '@today', ts: '@now' }, it_issues: { status: 'open', urgency: 'normal' }, kitchen_requests: { status: 'open', urgency: 'Normal', items_json: { items: [] } },
    maintenance_reports: { status: 'open', urgency: 'normal' }, stock_requests: { status: 'open', urgency: 'normal' }, refund_requests: { status: 'pending' }, premium_schedule: { status: 'scheduled', is_walkin: false, start_time: '', end_time: '', role_title: '' },
    liquor_bottles: { status: 'open', roll_color: '', issued_by: '', location: '', issued_at: '@now' }, liquor_bottle_events: { who: '', at: '@now' }, stand_chat: { event_date: '@day' }, checkins: { checked_in_at: '@now' },
    on_duty: { last_seen: '@now' }, stand_sheets: { exp_start: 0, on_hand: 0, restock: 0, is_addon: false, category: '', vendor: '', sku: '', chargeable: 'Y' }, schedule: { is_test: false, site: 'DFA' },
    staff_stand_access: { access_level: 'supervisor_limited', is_active: true, stands: [], worker_name: '', updated_by: '' }, game_day_assignments: { name: '', role: '', area_keys: [], direct_stands: [], backup_stands: [], notify_requests: true, source: 'manual', updated_by: '' },
    npo_members: { is_active: true, is_lead: false, notes: '' }, checklists: { entry_date: '@today' }, bus_conduct_signatures: { signed_at: '@now', policy_version: 'Aramark Employer Bus Code of Conduct v1' }, worker_moves: { moved_at: '@now' }
  };
  var STAMP = ['created_at', 'updated_at'];
  var UNIQUE = { app_settings: ['key'], on_duty: ['day', 'employee_id'], staff_stand_access: ['event_date', 'employee_id'], premium_schedule: ['event_date', 'employee_id'], bus_conduct_signatures: ['event_date', 'employee_id'], game_day_assignments: ['event_date', 'employee_id'], kitchen_runner_assignments: ['employee_id'], game_day_content: ['event_date', 'venue_key'] };
  function fill(tn, row) {
    var d = DEF[tn] || {};
    Object.keys(d).forEach(function (k) {
      if (row[k] !== undefined) return;
      var v = d[k]; row[k] = v === '@now' ? nowIso() : v === '@today' ? today() : v === '@day' ? demoDay() : (v && typeof v === 'object') ? JSON.parse(JSON.stringify(v)) : v;
    });
    STAMP.forEach(function (k) { if (row[k] === undefined) row[k] = nowIso(); });
    if (row.id === undefined) row.id = ++DB._id;
    return row;
  }

  // ---------- PostgREST filters ----------
  function unq(v) { v = String(v); return v.length > 1 && v[0] === '"' && v[v.length - 1] === '"' ? v.slice(1, -1) : v; }
  function splitTop(s) { var out = [], depth = 0, cur = '', q = false; for (var i = 0; i < s.length; i++) { var c = s[i]; if (c === '"') q = !q; if (!q && c === '(') depth++; if (!q && c === ')') depth--; if (!q && depth === 0 && c === ',') { out.push(cur); cur = ''; } else cur += c; } if (cur) out.push(cur); return out; }
  function cmp(a, b) {
    if (a === null || a === undefined) return null;
    var na = Number(a), nb = Number(b);
    if (typeof a !== 'boolean' && String(a).trim() !== '' && String(b).trim() !== '' && isFinite(na) && isFinite(nb)) return na - nb;
    var da = /^\d{4}-\d\d-\d\d/.test(String(a)) && Date.parse(a), db = /^\d{4}-\d\d-\d\d/.test(String(b)) && Date.parse(b);
    if (da && db) return da - db;
    return String(a) < String(b) ? -1 : String(a) > String(b) ? 1 : 0;
  }
  function likeRe(p, ci) { return new RegExp('^' + String(p).replace(/[.+?^${}()|[\]\\]/g, '\\$&').replace(/[*%]/g, '.*') + '$', ci ? 'i' : ''); }
  function test(row, col, expr) {
    var neg = false; if (expr.indexOf('not.') === 0) { neg = true; expr = expr.slice(4); }
    var dot = expr.indexOf('.'), op = expr.slice(0, dot), val = expr.slice(dot + 1), v = row[col], r;
    if (op === 'eq') r = v !== null && v !== undefined && (Array.isArray(v) ? false : String(v) === unq(val));
    else if (op === 'neq') r = !(v !== null && v !== undefined && String(v) === unq(val)) && v !== null && v !== undefined;
    else if (op === 'gt' || op === 'gte' || op === 'lt' || op === 'lte') { var c = cmp(v, unq(val)); r = c !== null && (op === 'gt' ? c > 0 : op === 'gte' ? c >= 0 : op === 'lt' ? c < 0 : c <= 0); }
    else if (op === 'like' || op === 'ilike') r = v !== null && v !== undefined && likeRe(unq(val), op === 'ilike').test(String(v));
    else if (op === 'in') { var list = splitTop(val.replace(/^\(/, '').replace(/\)$/, '')).map(unq); r = v !== null && v !== undefined && list.indexOf(String(v)) >= 0; }
    else if (op === 'is') r = val === 'null' ? (v === null || v === undefined) : val === 'true' ? v === true : val === 'false' ? v === false : false;
    else if (op === 'cs') { var want = val.replace(/^\{|\}$/g, '').split(',').map(unq); r = Array.isArray(v) && want.every(function (w) { return v.indexOf(w) >= 0; }); }
    else r = true;
    return neg ? !r : r;
  }
  function orTest(row, s) { return splitTop(s.replace(/^\(/, '').replace(/\)$/, '')).some(function (p) { if (/^and\(/.test(p)) return splitTop(p.slice(4, -1)).every(function (q) { var i = q.indexOf('.'); return test(row, q.slice(0, i), q.slice(i + 1)); }); var i = p.indexOf('.'); return test(row, p.slice(0, i), p.slice(i + 1)); }); }
  function parse(url) {
    var u = new URL(url), q = { filters: [], or: [], order: null, limit: null, offset: 0, onConflict: null };
    u.searchParams.forEach(function (v, k) {
      if (k === 'select' || k === 'columns') return;
      if (k === 'order') q.order = v; else if (k === 'limit') q.limit = +v; else if (k === 'offset') q.offset = +v; else if (k === 'on_conflict') q.onConflict = v.split(',');
      else if (k === 'or') q.or.push(v); else q.filters.push([k, v]);
    });
    q.match = function (row) { return q.filters.every(function (f) { return test(row, f[0], f[1]); }) && q.or.every(function (o) { return orTest(row, o); }); };
    return q;
  }
  function sortRows(rows, order) {
    if (!order) return rows;
    var keys = order.split(',').map(function (o) { var p = o.split('.'); return { c: p[0], desc: p.indexOf('desc') > 0, nf: p.indexOf('nullsfirst') > 0 }; });
    return rows.slice().sort(function (a, b) {
      for (var i = 0; i < keys.length; i++) { var k = keys[i], x = a[k.c], y = b[k.c], xn = x === null || x === undefined, yn = y === null || y === undefined;
        if (xn || yn) { if (xn && yn) continue; return (xn ? 1 : -1) * (k.nf ? -1 : 1); }
        var c = cmp(x, y); if (c) return k.desc ? -c : c; }
      return 0;
    });
  }
  function clone(x) { return JSON.parse(JSON.stringify(x)); }
  function json(body, status, extra) { return new Response(body === null ? null : JSON.stringify(body), { status: status || 200, headers: Object.assign({ 'Content-Type': 'application/json' }, extra || {}) }); }

  function rest(method, url, body, prefer) {
    var path = new URL(url).pathname.replace(/^.*\/rest\/v1\//, '');
    if (path.indexOf('rpc/') === 0) return json([]);
    var tn = decodeURIComponent(path), T = table(tn), q = parse(url), wantRep = /return=representation/.test(prefer || '');
    if (method === 'GET' || method === 'HEAD') {
      var rows = sortRows(T.filter(q.match), q.order).slice(q.offset, q.limit != null ? q.offset + q.limit : undefined);
      return json(clone(rows), 200, { 'Content-Range': '0-' + Math.max(0, rows.length - 1) + '/' + rows.length });
    }
    if (method === 'POST') {
      var list = [].concat(body || []), out = [], keys = q.onConflict || UNIQUE[tn] || null;
      for (var i = 0; i < list.length; i++) {
        var row = Object.assign({}, list[i]);
        var dupUuid = row.client_uuid && T.find(function (x) { return x.client_uuid === row.client_uuid; });
        var ex = keys && T.find(function (x) { return keys.every(function (k) { return String(x[k]) === String(row[k]); }); });
        if (tn === 'liquor_bottles' && (row.status || 'open') === 'open' && T.some(function (x) { return x.sticker_no === row.sticker_no && x.status === 'open'; }) && !dupUuid) return json({ code: '23505', message: 'duplicate key value violates unique constraint "liquor_bottles_open_sticker"' }, 409);
        var existing = ex || dupUuid;
        if (existing) {
          if (/ignore-duplicates/.test(prefer || '')) continue;
          if (/merge-duplicates/.test(prefer || '') || q.onConflict) { Object.assign(existing, row, { updated_at: nowIso() }); out.push(existing); continue; }
          return json({ code: '23505', message: 'duplicate key value violates unique constraint' }, 409);
        }
        T.push(fill(tn, row)); out.push(row);
      }
      save();
      return wantRep ? json(clone(out), 201) : json(null, 201);
    }
    if (method === 'PATCH') {
      var hit = T.filter(q.match); hit.forEach(function (x) { Object.assign(x, body || {}); }); save();
      return wantRep ? json(clone(hit)) : json(null, 204);
    }
    if (method === 'DELETE') {
      var gone = T.filter(q.match); DB[tn] = T.filter(function (x) { return !q.match(x); }); save();
      return wantRep ? json(clone(gone)) : json(null, 204);
    }
    return json({ message: 'demo: unsupported' }, 400);
  }

  // ---------- fetch hook ----------
  var realFetch = window.fetch.bind(window);
  window.fetch = function (input, init) {
    var url = typeof input === 'string' ? input : (input && input.url) || '';
    if (!/\.supabase\.co\//.test(url)) return realFetch(input, init);
    init = init || {};
    var method = (init.method || (input && input.method) || 'GET').toUpperCase();
    var h = init.headers || {}, prefer = (h.Prefer || h.prefer || (h.get && h.get('Prefer')) || '');
    return new Promise(function (resolve) {
      setTimeout(function () {
        try {
          if (/\/storage\/v1\//.test(url)) return resolve(json({ Key: 'demo/' + Date.now() + '.jpg' }));
          if (/\/functions\/v1\//.test(url)) return resolve(json({ ok: true, demo: true }));
          var body = null;
          if (init.body && typeof init.body === 'string') { try { body = JSON.parse(init.body); } catch (e) { body = null; } }
          resolve(rest(method, url, body, prefer));
        } catch (e) { resolve(json({ message: 'demo error: ' + e.message }, 500)); }
      }, 60);
    });
  };
  // No service worker on the demo (keeps demo and real app fully separate).
  try { if (navigator.serviceWorker) navigator.serviceWorker.register = function () { return Promise.resolve({ update: function () {}, addEventListener: function () {} }); }; } catch (e) {}

  load();
  window.STADIUM_OPS_DEMO = { reset: function () { DB = seed(); save(); try { Object.keys(localStorage).forEach(function (k) { if (k !== DB_KEY && !/^bt_label_size$/.test(k)) localStorage.removeItem(k); }); } catch (e) {} location.href = '/'; }, logins: DEMO_LOGINS };

  // ---------- banner ----------
  function esc(s) { return String(s).replace(/[&<>"]/g, function (c) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]; }); }
  function banner() {
    if (document.getElementById('demo-banner')) return;
    var b = document.createElement('div');
    b.id = 'demo-banner';
    b.style.cssText = 'position:fixed;left:8px;bottom:8px;z-index:2147483000;font:700 12px/1.2 Arial,sans-serif;display:flex;gap:6px;align-items:center';
    b.innerHTML = '<span style="background:#FFC627;color:#111;padding:7px 10px;border-radius:999px;box-shadow:0 2px 6px rgba(0,0,0,.25)">DEMO · fake data</span>' +
      '<button id="demo-logins-btn" style="background:#8C1D40;color:#fff;border:0;padding:7px 10px;border-radius:999px;font:inherit;box-shadow:0 2px 6px rgba(0,0,0,.25)">🔑 Logins</button>' +
      '<button id="demo-reset-btn" style="background:#fff;color:#8C1D40;border:1px solid #8C1D40;padding:6px 10px;border-radius:999px;font:inherit">↺ Reset</button>';
    document.body.appendChild(b);
    document.getElementById('demo-logins-btn').onclick = function () {
      var o = document.getElementById('demo-logins'); if (o) { o.remove(); return; }
      o = document.createElement('div'); o.id = 'demo-logins';
      o.style.cssText = 'position:fixed;left:8px;right:8px;bottom:52px;max-width:460px;max-height:70vh;overflow:auto;z-index:2147483000;background:#fff;color:#111;border-radius:12px;box-shadow:0 8px 30px rgba(0,0,0,.35);padding:12px 14px;font:13px/1.35 Arial,sans-serif';
      o.innerHTML = '<div style="font-weight:800;font-size:15px;margin-bottom:6px">Demo sign-ins (fake people)</div><div style="color:#555;font-size:12px;margin-bottom:8px">Use the normal sign-in screen. Everything you do stays in this browser only and resets daily.</div>' +
        DEMO_LOGINS.map(function (l) { return '<div style="padding:6px 0;border-top:1px solid #eee"><b>' + esc(l[0]) + '</b> <span style="color:#777">(' + esc(l[1]) + ')</span><br>' + esc(l[2]) + '</div>'; }).join('');
      document.body.appendChild(o);
    };
    document.getElementById('demo-reset-btn').onclick = function () { if (confirm('Reset the demo? This clears everything done in this browser and starts fresh.')) window.STADIUM_OPS_DEMO.reset(); };
  }
  if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', banner); else banner();
})();
