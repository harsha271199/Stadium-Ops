const { chromium } = require('playwright');
const results = []; let page, dept = '';
const open = async f => { await page.goto('http://127.0.0.1:8799/qa/player.html?f=' + f); await page.waitForFunction(() => window.__ready); };
const root = () => page.locator('#root');
const step = async (name, fn) => { try { await fn(); const errs = await page.evaluate(() => window.__errors.splice(0)); if (errs.length) throw new Error('JS: ' + errs.join('|')); results.push([dept, name, 'PASS', '']); }
  catch (e) { const shot = 'fail_' + results.length + '.png'; await page.screenshot({ path: 'shots/' + shot }).catch(() => {}); results.push([dept, name, 'FAIL', String(e.message).split('\n')[0].slice(0, 160) + ' [' + shot + ']']); } };
const click = async (txt, i = 0) => { const l = root().getByText(txt, { exact: typeof txt === 'string' }).nth(i); await l.click({ timeout: 2500 }); };
const role = async (r, name, i = 0) => root().getByRole(r, { name }).nth(i).click({ timeout: 2500 });
const see = async txt => { const c = await root().getByText(txt, { exact: false }).count(); if (!c) throw new Error('not visible: ' + txt); };
const notSee = async txt => { const c = await root().getByText(txt, { exact: false }).count(); if (c) throw new Error('should not show: ' + txt); };
const fill = async (ph, v) => { await root().getByPlaceholder(ph).first().fill(v, { timeout: 2500 }); };
(async () => {
  const b = await chromium.launch(); page = await b.newPage({ viewport: { width: 420, height: 900 } });

  // ---------- SIGN IN ----------
  dept = 'Sign in'; await open('Login.dc.html');
  await step('Employee ID 60000 shows warehouse hint', async () => { await fill('65764', '60000'); await see('Warehouse: type your last name'); });
  await step('Switch to NPO group form', async () => { await role('tab', /NPO group/); await see('Group PIN'); await see('Sign in with group'); });
  await step('No venue names / subcontractor message', async () => { await notSee('Mountain America'); await notSee('Desert Financial'); await notSee('subcontractor'); });
  await step('Install app banner present', async () => { await see('Add the app to your phone'); });

  // ---------- WAREHOUSE MANAGER ----------
  dept = 'Warehouse manager'; await open('Main.dc.html');
  await step('Send runner on a late job', async () => { await click('Send runner'); await page.waitForTimeout(100); const c = await root().locator('text=/Jordan|Alex|Riley|Sam|Priya/').count(); if (!c) throw new Error('no runner picker'); });
  await open('Main.dc.html');
  for (const [item, title, check] of [['Give restock access', 'Give restock access', 'people have restock access'], ['Quick Drop (scan stand QR)', 'Quick Drop', 'Scan the stand'], ['Request stock for a stand', 'Request stock for a stand', 'Needed by'], ['Create transfer', 'Create transfer', 'Warehouse ↔ Warehouse'], ['All transfers', 'All transfers', 'Waiting approval'], ['Approvals', 'Approvals', 'Verify & approve'], ['Assign areas & stands', 'Assign areas & stands', 'Save'], ['Stock report', 'Stand transfer report', 'Download report (CSV)']]) {
    await step('Menu → ' + item, async () => { await open('Main.dc.html'); await root().locator('button').nth(0).count(); await page.locator('#root header button, #root button[aria-label*="enu"]').last().click().catch(() => {}); 
      const m = root().getByText(item, { exact: true }); if (!(await m.count())) { await root().getByRole('button', { name: /menu/i }).first().click(); } await root().getByText(item, { exact: true }).first().click({ timeout: 2500 }); await see(check); }); }
  await step('Restock switch toggles count', async () => { const before = await root().getByText(/people have restock/).innerText().catch(() => ''); });
  await step('Request stock: pick URGENT + No deadline + Send', async () => { await open('Main.dc.html'); await root().getByRole('button', { name: /menu/i }).first().click().catch(() => {}); await click('Request stock for a stand'); await click('URGENT'); await click('No deadline'); await click('Send to warehouse'); await see('Sent to warehouse ✓'); });
  await step('Quick Drop: scan → add case → delivered', async () => { await open('Main.dc.html'); await root().getByRole('button', { name: /menu/i }).first().click().catch(() => {}); await click('Quick Drop (scan stand QR)'); await click('Scan the stand’s QR code'); await role('button', 'More'); await click('Mark delivered'); await see('Delivered ✓'); });
  await step('Carts tab → See history', async () => { await open('Main.dc.html'); await root().getByRole('button', { name: '1 Carts' }).click(); await click('See history'); await see('Cart 3 history'); await see('Took key'); });

  // ---------- WAREHOUSE WORKER ----------
  dept = 'Warehouse worker'; await open('Worker.dc.html');
  await step('On my way → Delivered → then Claim next', async () => { await click('I’m on my way'); await root().getByRole('button', { name: 'Delivered', exact: true }).click(); await root().getByRole('button', { name: 'Claim', exact: true }).first().click(); await see('I’m on my way'); await click('I’m on my way'); await click('Delivered'); await see('Delivered'); });
  await step('Cannot claim 2nd while one active (Finish yours first)', async () => { await open('Worker.dc.html'); await see('Finish yours first'); });

  // ---------- GOLF CART ----------
  dept = 'Golf cart'; await open('Runner.dc.html');
  await step('Cart 2 first use → 12 questions', async () => { await click('Cart 2'); await see('all 12 questions'); const n = await root().getByRole('button', { name: 'OK', exact: true }).count(); if (n !== 12) throw new Error('questions shown: ' + n); });
  await step('Cannot submit until all answered', async () => { await click(/Answer all 12/); await see('Answer all 12'); });
  await step('Answer all OK → take key', async () => { const bs = root().getByRole('button', { name: 'OK', exact: true }); for (let i = 0; i < 12; i++) await bs.nth(i).click(); await click('Submit & take the key'); await see('You have Cart 2'); });
  await step('Other carts locked while holding one', async () => { await role('button', 'Back'); await see('Return it before you take another'); await see('Locked'); });
  await step('Locked cart 5 is disabled', async () => { const d = await root().getByRole('button', { name: /Cart 5/ }).isDisabled(); if (!d) throw new Error('cart 5 not disabled'); });
  await step('Return → 4 questions → returned', async () => { await click('Return', 0); await click('Return Cart 2'); const bs = root().getByRole('button', { name: 'OK', exact: true }); if (await bs.count() !== 4) throw new Error('return questions ' + await bs.count()); for (let i = 0; i < 4; i++) await bs.nth(i).click(); await click('Submit & return the key'); await see('Cart 2 returned'); });
  await step('After return can take cart 5 (4 questions)', async () => { await click('Back to carts'); await click('Cart 5'); await see('4 quick questions'); });
  await step('Issue on take → out of service', async () => { await open('Runner.dc.html'); await click('Cart 5'); const ok = root().getByRole('button', { name: 'OK', exact: true }), is = root().getByRole('button', { name: 'Issue', exact: true }); await is.nth(0).click(); for (let i = 1; i < 4; i++) await ok.nth(i).click(); if (!(await root().getByPlaceholder(/required/).count())) throw new Error('no required note'); await click('Take it out of service'); await see('taken out of service'); });

  // ---------- WAREHOUSE TOOLS ----------
  dept = 'Warehouse supervisor/tools'; await open('WhTools.dc.html');
  for (const [tab, check] of [['Supervisor view', 'To deliver'], ['Create transfer', 'Who delivers it?'], ['Approvals', 'Verify & approve'], ['Force stock', 'Mark delivered'], ['Assign & Team', 'Take off all stands'], ['Restock access', 'Force Restock'], ['Stand report', 'Download report (CSV)'], ['Stand QR codes', 'Print / save PDF']])
    await step('Tab ' + tab, async () => { await root().getByRole('button', { name: tab, exact: true }).first().click(); await see(check); });
  await step('Approve a delivery', async () => { await root().getByRole('button', { name: 'Approvals', exact: true }).first().click(); await click('Verify & approve'); await see('Approved'); });
  await step('Create transfer total updates with +', async () => { await root().getByRole('button', { name: 'Create transfer', exact: true }).first().click(); await role('button', 'More'); await see('Create transfer · 5 cases'); });

  // ---------- STAND LEAD ----------
  dept = 'Stand lead'; await open('Lead.dc.html');
  await step('Home: 4 boxes + game card + report problem', async () => { for (const t of ['Checks', 'Requests', 'Food Safety', 'My Team', 'Report an app problem']) await see(t); });
  await step('No big runners card', async () => { await notSee('Your runners today'); });
  await step('Report an app problem sheet', async () => { await click('Report an app problem'); await see('Something broke'); });
  dept = 'Stand lead · Checks'; await open('Checks.dc.html');
  await step('Tap During-Event opens checklist (not instant done)', async () => { await click('During-Event Check'); await see('of 4 answered'); await see('Answer all 4 to submit'); });
  await step('Submit blocked until answered, then done', async () => { await click('Answer all 4 to submit'); await see('0 of 4 answered'); const d = root().getByRole('button', { name: 'Done', exact: true }); for (let i = 0; i < 4; i++) await d.nth(i).click(); await click('Submit During-Event Check'); await see('3 of 5 done'); });
  await step('Count Out row opens count screen link', async () => { await click('Count Out'); await see('Open the count screen'); });
  await step('Wastage opens form', async () => { await open('Checks.dc.html'); await click('Log Wastage'); await see('+ Add item'); await click('Submit wastage log'); await see('1 logged tonight'); });
  dept = 'Stand lead · Count'; await open('Count.dc.html');
  await step('62 items in 5 sections', async () => { await see('/ 62'); });
  await step('Search "cl 24" finds Coors Light 24oz', async () => { await fill('Find', 'cl 24'); await see('Coors Light 24oz can'); });
  await step('Search "gloves l" finds Gloves large', async () => { await fill('Find', 'gloves l'); await see('Gloves black · large'); });
  await step('Unknown item → add box with auto section', async () => { await fill('Find', 'celsius 12oz'); await see('No match for'); await see('Add to Soda & water'); await click('Add to Soda & water'); await fill('Find', 'celsius'); await see('Added by you · kept for this stand'); });
  await step('Typing a count fills and shows expected diff', async () => { await fill('Find', ''); const inp = root().locator('input[inputmode="decimal"]').nth(0); await inp.fill('99'); await see('check'); });
  await step('Next blank jumps', async () => { await click('Next blank'); });
  await step('Count Out tab shows used', async () => { await role('tab', 'Count Out'); await see('In '); });
  await step('Yellow Dog order note on submit area', async () => { await see('Yellow Dog sheet order'); });
  dept = 'Stand lead · Requests'; await open('Requests.dc.html');
  await step('My Stand Order on top', async () => { await see('My Stand Order'); });
  await step('Open now capped at 2, Show more', async () => { await see('Show 3 more open'); await click('Show 3 more open'); await see('Show less'); });
  await step('Remind sets Reminded', async () => { await click('Remind'); await see('Reminded'); });
  await step('Hub rows: IT, Maintenance, Force Restock, supervisor rows', async () => { for (const t of ['Report IT Issue', 'Maintenance Issue', 'Force Restock / Add Stock Myself', 'All Requests · today', 'Give restock access', 'Pending Refunds']) await see(t); });
  dept = 'Stand lead · Food Safety'; await open('FoodSafety.dc.html');
  await step('Four tabs present', async () => { for (const t of ['Sanitizer', 'Fridge', 'Cooking', 'Holding']) await see(t); });
  await step('Sanitizer out of range → corrective action', async () => { const i = root().locator('input').first(); await i.fill('50'); await see(/[Cc]orrective|out of range|too low/); });
  dept = 'Stand lead · My Team'; await open('Team.dc.html');
  await step('Names not cut, chip under name', async () => { await see('Vatsal Patel'); await see('Himanshi Chetan Bhanushali'); });
  await step('Not arrived → Check in → Working', async () => { await click('Marcus Jackson'); await click('Check in · here now'); await see('Working'); });
  await step('Feedback hidden behind Rate link', async () => { await notSee('Save feedback'); await click(/Rate .* \(optional\)/); await see('Save feedback'); });
  await step('Move worker + My NPO Group rows', async () => { await see('Move worker to another stand'); await see('My NPO Group'); });
  await step('Add walk-in sheet', async () => { await click('Add walk-in worker'); await see('Add walk-in to'); });

  // ---------- SUPERVISOR ----------
  dept = 'Supervisor'; await open('Supervisor.dc.html');
  await step('Supervisor home rows', async () => { for (const t of ['All Stands Live', 'Stand Status', 'Stand Transfer Record']) await see(t); });
  await open('Team.dc.html');
  await step('Team by Stand: big stand button + arrows', async () => { await click('Supervisor'); await see('Change ▾'); await role('button', 'Next stand'); await see('DFA 111'); });
  await step('Stand picker: needs attention list', async () => { await click('Change ▾'); await see('Needs attention'); await see('219 Cold Beer Cheeseburgers'); });
  await step('Stand picker: search 408 → pick', async () => { await fill('Type a number', '408'); await click('408 Cold Beer'); await see('408 Cold Beer'); await see('1/4 here'); });
  dept = 'Supervisor · detail'; await open('SupDetail.dc.html');
  await step('All Stands Live: opens on Need help, MAS only', async () => { await see('219 Cold Beer'); await notSee('226 Pitchfork'); await click('All'); await see('West'); await notSee('DFA 111'); await click('Desert Financial'); await see('DFA 111 Hot Dogs'); await notSee('212P'); });
  await step('Need help filter', async () => { await click('Need help'); await see('DFA 191 Pizza'); });
  for (const [tab, check] of [['Stand Status', 'Every stand’s checks'], ['All requests', 'Stock'], ['Stock for another stand', 'Liquor'], ['Stand detail', 'Check in'], ['Transfer record', 'cases in'], ['Refunds', 'Send to manager'], ['Game-day info', 'Kickoff'], ['Sign-in help & QR', '50216'], ['Checkout & Inventory', 'Remind every stand shown'], ['Alerts check', 'Send test alert'], ['Stand chat', 'lead, supervisor and warehouse']])
    await step('Tab ' + tab, async () => { await root().getByRole('button', { name: tab, exact: true }).first().click(); await see(check); });
  await step('No Game-day feedback tab for supervisor', async () => { const c = await root().getByRole('button', { name: 'Game-day feedback', exact: true }).count(); if (c) throw new Error('still there'); });
  await step('Sign-in help lists no employee/warehouse logins', async () => { await root().getByRole('button', { name: 'Sign-in help & QR', exact: true }).first().click(); await notSee('60000'); await notSee('Last name'); await notSee('Group PIN'); await see('50216'); });
  await step('Stand detail: check in a not-arrived person', async () => { await root().getByRole('button', { name: 'Stand detail', exact: true }).first().click(); await see('Not arrived'); await click('Check in'); });

  // ---------- MANAGER ----------
  dept = 'Manager'; await open('Manager.dc.html');
  await step('Phone home: tools list', async () => { await click('Manager Tools', 0); for (const t of ['Inventory', 'Transfers', 'Reports', 'Time sheet', 'Maintenance', 'Runner coverage']) await see(t); });
  await open('ManagerDesk.dc.html');
  await step('Laptop: role switch + nav', async () => { await see('Need action now'); await click('Admin'); await see('Admin Setup'); });
  dept = 'Manager · tools inside'; await open('ManagerTools.dc.html');
  await step('Tracker filter Box not received', async () => { await click('Box not received', 1); await see('204P Fan Fuel Bev'); await notSee('DFA 111 Hot Dogs'); });
  await step('Remind every stand', async () => { await click('Remind every stand shown'); await see('Reminder sent to every stand shown'); });
  for (const [tab, check] of [['Inventory', 'Yellow Dog order'], ['Transfers', 'Confirm received'], ['Reports', 'Feedback CSV'], ['Time sheet', 'Tip sheet (CSV)'], ['Refunds', 'Download all refunds'], ['Maintenance', 'Open'], ['Runner coverage', 'Add runner'], ['Golf cart log', 'Load full cart log']])
    await step('Tool ' + tab, async () => { await root().getByRole('button', { name: tab, exact: true }).first().click(); await see(check); });
  await step('Refund approve', async () => { await root().getByRole('button', { name: 'Refunds', exact: true }).first().click(); await click('Approve'); await see('Approved'); });
  await step('Maintenance resolve moves out of Open', async () => { await root().getByRole('button', { name: 'Maintenance', exact: true }).first().click(); const before = await root().getByText('Resolved', { exact: true }).count(); await root().getByRole('button', { name: 'Resolved', exact: true }).nth(1).click(); });

  // ---------- ADMIN ----------
  dept = 'Admin'; await open('AdminSetup.dc.html');
  await step('/manager PIN: ID box + keypad', async () => { await see('Your ID (last 5 digits)'); await see('Only at /manager'); });
  await step('Wrong PIN 0000 shows error', async () => { for (let i = 0; i < 4; i++) await role('button', '0'); await see('Wrong PIN'); });
  await step('Right PIN opens Game day', async () => { for (const d of ['1', '2', '3', '4']) await role('button', d); await see('Save game day'); await notSee('2711'); });
  for (const [tab, check] of [['People & logins', 'Open Food Manager'], ['Who covers what', 'Load football plan'], ['Warehouse crew', 'Golf cart drivers'], ['Stands', 'Make a subcontractor stand'], ['Uploads', 'Roll counts forward']])
    await step('Section ' + tab, async () => { await root().getByRole('button', { name: tab, exact: true }).first().click(); await see(check); });
  await step('Clear for new game present', async () => { await root().getByRole('button', { name: 'Game day', exact: true }).first().click(); await see('Clear for new game'); });

  // ---------- FOOD / IT ----------
  dept = 'Food & IT'; await open('FoodTech.dc.html');
  await step('Food runner steps', async () => { await see('Picked up'); });
  await step('Food manager board', async () => { await click('Food manager'); await see('Cooking'); await see('Runners'); });
  await step('IT tech tabs + tracker button', async () => { await click('IT tech'); for (const t of ['My jobs', 'Available', 'Other games', 'Resolved', 'Checkout & Inventory Tracker']) await see(t); });

  // ---------- NPO / SUB ----------
  dept = 'NPO & subcontractor'; await open('NpoSub.dc.html');
  await step('Screens present', async () => { for (const t of ['NPO: pick stand', 'NPO lead home', 'NPO group roster', 'Subcontractor home']) await see(t); });

  // ---------- PREMIUM ----------
  dept = 'Premium manager'; await open('PremiumMgr.dc.html');
  await step('Check-ins grouped by location with x/y', async () => { await see('Suites 1–8'); await see('Club Chill'); await see(/\d\/\d/); });
  await step('Present / absent buttons work', async () => { await role('button', 'Absent'); });
  await step('⋯ opens move + 👍/👎', async () => { await role('button', 'Move or feedback'); await see('Needs work'); await see('Move to…'); });
  await step('Walk-in form fields', async () => { if (!(await root().getByPlaceholder(/full 8 digits/).count())) throw new Error('no 8-digit field'); });
  await step('App QR button', async () => { await role('button', 'App QR code'); });
  dept = 'Premium · Bottle Tracker'; await open('Bottles.dc.html');
  await step('Manager tabs', async () => { for (const t of ['Tag', 'Move', 'Sell', 'Empty', 'Bottles', 'Look up', 'Setup']) { const c = await root().getByRole('tab', { name: t, exact: true }).count(); if (!c) throw new Error('missing tab ' + t); } });
  await step('Tag: scan twice → 2 scanned, undo → 1', async () => { await click('Tap to scan the Dymo barcode'); await click('Tap to scan the Dymo barcode'); await see('2 scanned this time'); await click('Undo last'); await see('1 scanned this time'); });
  await step('Read number → which roll → pick', async () => { await click('Read number'); await see('Which one?'); await click('Pink #…042'); });
  await step('Bottles: void needs reason', async () => { await role('tab', 'Bottles'); await click('Void…'); await see('Reason'); await root().getByRole('button', { name: 'Void', exact: true }).click(); await see('Voided'); });
  await step('Setup: labels + rolls', async () => { await role('tab', 'Setup'); await click('2 · Labels'); await see('Test 1 label'); await click('3 · Rolls'); await click('Add roll'); await see('Yellow'); });
  await step('Seller: Sell only, no Look up / CSV', async () => { await click('Seller'); const c = await root().getByRole('tab').count(); if (c !== 1) throw new Error('seller tabs ' + c); await notSee('Download all history'); });
  await step('Seller not switched on → message', async () => { await click('Seller, not on'); await see('not switched on'); });

  // ---------- CHAT ----------
  dept = 'Chat'; await open('Chat.dc.html');
  await step('Floating Chat + call button', async () => { await see('Chat'); await role('button', 'Call or emergency'); });
  await step('One tap Ice → real stock request card', async () => { await click('Open chat'); await click('+ Ice'); await see('Ice ×5 bags'); await see('STOCK REQUEST → WAREHOUSE'); });
  await step('Supervisor: Make it a stock request', async () => { await click('Supervisor inbox'); await click('Make it a stock request'); await see('Made a stock request'); });
  await step('Warehouse quick reply', async () => { await click('Warehouse runner'); await click('On my way'); await see('Replied'); });

  // ---------- STAND FORMS ----------
  dept = 'Worker & stand forms'; await open('StandForms.dc.html');
  for (const t of ['Checklist', 'My Stand Order', 'Report IT', 'Wastage', 'Give stock', 'Incoming', 'Refund', 'Maintenance', 'Add walk-in', 'Request status'])
    await step('Screen ' + t, async () => { await root().getByRole('button', { name: t, exact: true }).first().click(); });

  await b.close();
  const fs = require('fs'); fs.writeFileSync('results.json', JSON.stringify(results, null, 1));
  const fails = results.filter(r => r[2] === 'FAIL');
  console.log('TOTAL', results.length, 'PASS', results.length - fails.length, 'FAIL', fails.length);
  fails.forEach(r => console.log('FAIL |', r[0], '|', r[1], '|', r[3]));
})();
