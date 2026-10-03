# Changelog

Builds are tagged in `index.html` as `BUILD_TAG` and shown on the login
screen footer. Newest first. Dates are the build date, not necessarily
the deploy date — always verify the tag on the live site after deploying.

## 2026-10-03-fix-14
- Warehouse leaders' RIGHT NOW: Waiting / Overdue open **Requests → Open**, On the way opens **Requests → In Progress** (was opening All Transfers). Leaders' Requests list shows every stand by default.
- Game day 10/3 is requests + Force Stock only: Create Transfer, All Transfers, Approvals and the "To verify" chip are hidden; Manager tools leads with **Stand Requests** and has a **Force Stock** button.

## 2026-10-03-fix-13
- Admin "Multi-Stand Coverage" now lists Supervisors as well as Stand Leads (Supervisors first, labelled). Saving limits that person to only the checked stands, with Stand Lead tools and a stand picker. "Remove temporary access" gives a Supervisor back their full view.
- One-tap area buttons (Inferno, West Concourse, North/Draft Houses 215–221, East Concourse, Upper West, Upper East) add a whole area's stands.

## 2026-10-03-fix-12
- Supervisor limited to an area (staff_stand_access `supervisor_limited`) now works for scheduled Supervisors too: Stand Lead tools + a picker of only those stands. Kijana Gaines → North concourse (215–221) for 10/3.
- Warehouse Manager/Supervisor land on **My Jobs** (same list as every warehouse person, Quick Drop on top); everything else is behind one **🛠️ Manager tools** button (red count when deliveries wait for sign-off). Phone back: Manager tools → My Jobs.
- Quick Drop moved to the top of the job list for everyone.
- Admin: **🏭 Warehouse walk-in & check-in** card — add walk-ins or new hires (ID + name, even if not in the employee list) and check the crew in/out. New hires sign in with 60000 + last name.

## 2026-10-03-fix-11
- Premium Managers can sign in with the last 5 of their ID + last name (same as Managers). Nestor Hernandez added as Premium Manager under his real ID 20532480.

## 2026-10-03-fix-10
- Only the Food Manager can decline a food order (runners never see Decline, and the save itself refuses anyone else).
- Food Manager's "Delivered" tab now shows today's history in two parts: ✅ Delivered and ❌ Declined (with the reply). Neither appears in the normal order list.

## 2026-10-03-fix-9
- **Food Manager → Assign Runners uses the same 6 groups as the warehouse** (Inferno · West Concourse · Draft Houses · East Concourse · Upper West · Upper East). Orders from a stand go straight to the runner(s) of that group; runners see their group name at the top.
- **Decline with a reply:** Food Manager can ✖ Decline an order with one tap reasons (Not available right now · Kitchen can't make it right now · Sold out · Duplicate order) or a typed reply. The stand gets an alert with the reason and sees it in red on the food form; the runner already assigned is told not to deliver. Stored in `kitchen_requests.declined_reason / declined_by`.
- Delivered and declined orders leave the Food Manager's and runners' lists (the Food Manager can still open the "Delivered" count).
- Removed old QA log files (`QA_PROGRESS.md`, `tests.json`) from the repo.

## 2026-10-03-fix-8
- **Warehouse duplicates:** a person who had a temp walk-in account (…60000) and a real-ID account showed twice. Lists now show each person once (the roster / real-ID account wins); the three unused walk-in duplicates (Birhade, Vijayakumar, Chaudhari) were set inactive. The warehouse roster list also shows each person once.
- **Food targets:** Normal 30 min, Urgent 15 min. A food order only counts as LATE 10 minutes after its target — until then it shows "due now". The Food Manager's late alert, red overdue labels and the managers' overdue counts all use the same 10-minute grace.

## 2026-10-03-fix-7
- **Checkout & Inventory Tracker (Managers / Admin only):** the Inventory Tracker now also tracks the end-of-game boxes at the exit table. Each stand shows Count In / Count Out and its box (kit list + inventory sheets + POS for portables). "📦 Receive box" opens a checklist — untick anything missing and confirm. Filters: Box not received · Missing Count Out · Missing Count In · Received · All, plus search. "Who is missing what" lists every box that came back short. Undo is available. Kit lists live in `checkout_kits` (61 stands); receipts in `checkout_receipts`.
- Supervisors and Support Managers no longer see the tracker.
- **IT Tech:** sign in with last 5 + last name (PIN still works); claim / resolve messages use the app's own dialog; a claimed ticket can be released back to Available.
- **Food requests:** default target 15 minutes (Soon 12, URGENT 10).
- **Chat requests:** Refund / Customer complaint / Comp / SOS send even with nothing typed; anything typed rides along ("Refund — $12 hot dog"). The chat box hint shows an example.
- **Back button:** page headers stay pinned at the top while scrolling (My Team, long lists), and the phone's swipe-back now does exactly what the screen's ← Back does.

## 2026-10-03-fix-6
- **Runners split:** the old "Kitchen Runner" list is now **Concession Runner** (the 5 Food Runners) and **Warehouse Runner** (9 people, added to the Oct 3 warehouse roster). Warehouse Runners can sign in with 60000 + last name or their own last 5 + last name, and land in Warehouse. Runner groups no longer show up as "stands" in Stand Status, and Warehouse Runners are not in the concession Team list.
- **Warehouse groups (Assign & Team):** 1 Inferno (140, 142) · 2 West Concourse (203–214) · 3 Draft Houses (215–221) · 4 East Concourse (222–234) · 5 Upper West (310, 316, 401–414) · 6 Upper East (334, 348, 438, 442). Stock requests alert only the people assigned to that stand's group; an unassigned manager transfer now alerts that group too. Warehouse leaders' chat name shows their group (e.g. "Warehouse Supervisor · West Concourse").
- **Inventory counts:** Count In / Count Out boxes start empty (no grey 0). Every item must have a real number (0 only if there are none); blanks and negative numbers are refused.
- **No inventory override:** a Stand Lead — or the last person at a stand with no Stand Lead — cannot be checked out by anyone (lead, supervisor, manager, admin) until Count In and Count Out are complete. The block offers "Open Count Out" so whoever is checking them out can finish it. The lead's own Leave button re-checks too.

## 2026-10-03-fix-5
- **All Requests (managers / Support Managers / supervisors):** the "View requests" picker is now a stand drop-down — **All stands** first, then NPO stands, then every other stand. Pick one to see only that stand's Stock / Food / IT requests.

## 2026-10-03-fix-4
- **Manager / Support Manager requests:** back to the original **Stand Requests** screen (Back at the top, "Working stand / All stands", the 📦 Stock / 🍔 Food / 🔧 IT boxes). Only the "All" box is removed, so one type shows at a time (Stock first). No "New request" button on it. Opened from Requests → All Requests · today.
- **NPO sign-in is forgiving:** after picking the group and PIN, the name can be first name only, last name only, either order, a short start ("Sean L") or have small typos. If more than one member fits (e.g. two "Lopez"), they tap their name from a short list. Unknown names are still refused.
- Fixed a missing helper (`npoFuzzyFind`) used when the NPO group list can't load.

## 2026-10-03-fix-3
- **Why yesterday's chat / requests / "23 stands" still showed:** before 6 AM Arizona the app counted the night as the previous game day, so at 2–5 AM on Oct 3 it was still showing Oct 2 test data. Oct 3 is now the first game day: nothing before it is ever "today", and Oct 3 lists start at midnight.
- **Manager requests list:** back to the plain list (OPEN NOW, then RECENTLY FINISHED). The open / in-progress / overdue tiles and the search are gone; only the "All" filter was removed (Stock · Food · IT stay). It now has a Back button.
- **iPhone Back button:** page headers now leave room for the iPhone's top status area, so Back is no longer hidden under it.
- **Stand Status and Inventory Tracker** list every scheduled stand plus every NPO stand.
- **Requests hub:** Refund Assistance sits right after Report IT Issue.
- **Manager home:** Stand Transfer Record removed.
- **Add walk-in** (manager, support, supervisor, stand lead): descriptions removed.
- **Notifications switch (Admin):** a card on the Admin home turns staff notifications ON (live) or OFF (testing). When OFF nobody gets a push except the admin who switched it off. Stored in the `app_settings` table.

## 2026-10-03-fix-2
- **Manager "All Requests" was blank:** a style rule hid the whole panel when opened from the manager home. Fixed. The monitor now has an **All stands / one stand** picker and **Stock · Food · IT** filters only (no "All"), today's requests only.
- **Old requests / chat everywhere:** refund, maintenance and pending stand-transfer lists are now today-only too (requests, IT, food and chat already were).
- **Manager home:** no "Hi …", no repeated Working stand text, no "All-stand operations…" line — compact card like the Supervisor's.
- **IT form:** the IT-only reminder now sits next to the Details box, not as a banner on top.
- **Stock request:** only Supervisors and Managers/Admin can type a custom ("Other") request or notes; everyone else picks from the list and asks their Supervisor. Same for the Force Restock manual-add box.
- **Chat:** managers are no longer alerted for a stand chat until an Admin assigns them in Chat routing.
- **Inventory Tracker:** counts every stand an active NPO group is assigned to (scheduled stands + NPO stands), even before anyone checks in.

## 2026-10-03-fix-1
- **Manager portal:** the game-day banner (ASU vs Baylor) is now the first card on the home screen, same look as the Supervisor's. Under "All Stands" the **Inventory Tracker** is first and the duplicate "All Requests" button is gone.
- **Team (manager / admin):** three clickable options only — **All stands · Workers · NPO**. The "Working stand", "Live now", the Fully staffed / Partial / None / Checked-in chips and the filter buttons are removed. Every worker row (in All stands, Workers and NPO) has ✓ check-in, **Check out** (once checked in), ✕ absent, ↔ move and ⭐ feedback.
- **Requests:** "See Existing Requests" and "My IT Tickets" are removed for Stand Leads, workers and Supervisors, and the Supervisor's "All Requests" button is gone. Managers / Support Managers / Admin keep ONE "All Requests · today" monitor inside the Requests tile. Request lists show today only (6 AM rollover) and delivered / resolved Food requests no longer show to stands.
- **IT form:** clear red notice — IT ONLY, not for food, stock, refunds. If the details read like food/stock and not a tech problem it asks before sending.
- **Food form:** one box ("Food order — type the food and how many"). No menu suggestions, no separate quantity or notes boxes. Saved exactly as typed.
- **Chat:** Refund, Customer complaint and Comp / price must include the item and price/detail before they send (SOS unchanged). All times in the app show in Arizona time (MST), chat times say MST.
- **Force Restock** (and Quick Drop) only offers Chargeable items. The full sheet (including Non-Chargeable and Supplies) stays for counts and the end-of-game download.
- **Inventory:** Count In and Count Out must be complete — every item needs a number (type 0 if none); blank items are highlighted and the count will not save. Add-on items stay optional.
- **Check-out rules:** regular workers can no longer check themselves out — only their Stand Lead (or a Supervisor / Manager) can. A Stand Lead cannot check out until Count In **and** Count Out are complete (a half-filled count does not unlock it), and if the app cannot verify inventory (no signal) it refuses instead of letting them leave. Supervisors / Managers can still override with a recorded reason.
- **Data (live database):** 6 new people scheduled (Shaik, Mansi Nayak at 229P Fan Fuel; Chasiti Thomas at 438); Saragadam moved to 334 San Tan; Krish Shah moved to 203P Beer Portable (to be assigned); inventory for all Stinger stands = Lemonade list; 219T BBQ Trailer and 221P Taco Bar = Fork 'Em BBQ list.

## 2026-10-02-grp-2
- **Open-request limits per stand** (replaces the one-at-a-time rule from grp-1): **IT 1**, **Food 3**, **Stock 3** for portables and small kiosks (P / M / T / B stands) and **5** for the big stands. The moment a request is delivered or resolved its slot frees up and the stand can send the next. The old 10-minute Food hold is gone (the limit replaces it).
- **Fresh game: no old requests anywhere.** Stock, Food and IT lists (stand screens, manager/support views, warehouse queue, "My IT tickets") only show requests from the current game day (the day rolls over at 6 AM). Chat already only showed the current day.
- Live database: 9/30 practice data removed (test accounts, schedule, kitchen runner assignment, practice chat, on-duty log, and practice stock requests / transfers after the Sep 5–6 game). Warehouse logins created for Cassidy Cole and Shawn Harris (60000 + last name).

## 2026-10-02-grp-1
- **One open request per stand — Stock, Food and IT.** If a stand already has an open request of that type (not yet delivered / resolved), a second one is refused with who sent it and when. Checked live against the database at the moment of sending, so two phones can't both slip one through; only the last 18 hours count so an old row can't lock a stand. Other stands, and other request types, are unaffected. Once the request is delivered or resolved, the stand can send a new one.
- **Temp warehouse workers (walk-ins).** Warehouse Manager / Supervisor → Roster → **➕ Add temp warehouse worker**: search the name (or employee ID) in the ASU employee list, tap the person, confirm. They get a warehouse login with their real employee ID, sign in with **60000 + last name**, and are added to today's roster so they show in check-in and in Assign & Team.
- **Assign & Team is now by Group.** Six groups by stand number — 1 Gates & Inferno, 2 West 203–210, 3 West 211–221, 4 East 222–234, 5 300s, 6 400s. Tap a person → tap their group(s). **☑ Select several** lets you tick many people and put them all in a group with one tap. Top of the screen shows how many people are in each group. Individual stands are still available under "Need one single stand instead?". Coverage is still stored as plain stands, so request routing and "My Stands" work as before.
- **No verification or e-signature on Oct 2 and Oct 3.** A warehouse delivery is final when the worker taps Delivered — even for manager-planned transfers — and inventory is still logged. Other dates are unchanged (`WH_SKIP_VERIFY_DATES`).

## 2026-10-02-wh-1
- **Warehouse screens show "First Last".** Warehouse staff sign in with 60000 + last name as before, and the database keeps "Last, First", so nothing about sign-in or matching changed. What changed is how names are displayed on warehouse screens:
  - the check-in / My Team roster (search finds "eli qaw" as well as "qawhemp"), Assign & Team, and the "assign to" list in Create Transfer;
  - the deliveries list, All Transfers, Approvals, and the delivery / verify screen ("Delivered by Eli Qawhemp", "Verified by …", "Assigned to: … by …");
  - golf cart drivers, duty and flagged-cart lists;
  - warehouse alerts ("approved by Wanda Qawhmgr", "Delivered by …").
  Warehouse chat already did this. Stand, manager and supervisor screens are unchanged.

## 2026-10-02-inv-1
- **Stand Leads and Supervisors can sign in on a day they aren't scheduled.** They land on their most recent stand (or their next one if they've never worked). The home screen says "📅 Not scheduled today · last shift Sep 27". Regular workers still need today's schedule.
- **Premium gets the game-day card** concessions already had: event, date, gates, kickoff, meals and reminders (from Admin → Game Day Information). Tapping it opens the full details screen.
- **Admin → Upload inventory now matches the file to the app's stands before saving.**
  - **Matching:** exact name, a known rename, or the nearest stand (same number and same kind, e.g. "207 Sun Devil Burger & Tenders" → "207 Sun Devil Burgers & Tenders", "204P Fan Fuel Bev Market" → "204P Fan Fuel Beverage MKT").
  - **Family fill:** a stand the file doesn't cover gets the list of the same kind of stand — Beer Portables, Fan Fuel Beverage markets (incl. Mashgin/S4), Chick-fil-A, Stinger, Bahama Bucks, Bar S Sausage, Someburros, Game Day, Draft House, Sun Devil Burgers & Tenders, Pitchfork, Nacho, Venezia, Huss Hideout, Cold Beer Cheeseburgers, Gate Dogs. A P stand prefers a P stand, an M stand an M stand.
  - **Review first:** a match report (✅ exact · 🔎 nearest · 🧬 filled from same kind · ⚠️ no list · 📄 in file but not an app stand) shows before anything is replaced, and again after the upload.
  - **Order kept:** each stand keeps the file's item order (`sort_order`), plus Category / Vendor / SKU when the file has them. Count In / Count Out and the end-of-day report follow that order.
- **Fixed: inventory upload failed when On Hand, Restock or Exp Start was blank or missing.** The database rejects empty text in number columns ("Failed after 0 rows"). Blanks are now saved as empty.

## 2026-10-01-ui-2
- **Sign-in accepts a name that's mostly right.** The ID digits are still required. The name can now be:
  - a few letters off, scaled to its length: 1 for 4–5 letters, 2 for 6–8, 3 for 9+ ("bntley", "flenrd", "herandez", "vangamplr");
  - any 4+ letters from inside it ("entley");
  - the first name alone if it's unique.
  
  The closest match wins, so "qawhsupp" signs in Qawhsup, not Qawhemp. Two people with the same last name still get asked for the full name, and one or two letters alone are still rejected.
- **No more zooming while entering stock.** The page header now stops the phone from zooming into input boxes, and a style stops the double-tap zoom when tapping + / − quickly. This applies to every screen.
- **Group alerts only reach people signed in today.** These used to go to every active account in the group:
  - new stock request at a stand with no warehouse person assigned (all ~40 warehouse accounts);
  - new IT ticket (every tech);
  - food order with no runner (every runner and Food Manager);
  - warehouse sign-offs, "ready to verify", golf-cart flags (every warehouse leader);
  - late stock with nobody covering the stand (every warehouse manager);
  - late food (every Food Manager).
- **One alert per event.**
  - When the warehouse claims or delivers a stock request, the requester gets one alert. The stand's other Stand Lead(s) get one only if they didn't ask (before, the requester got both "Stock is on the way" and "Warehouse on the way").
  - Stand supervisors are no longer buzzed for every routine delivery or IT update; Stand Leads still are.
  - Titles: "🚚 Stock on the way · stand", "✅ Stock delivered · stand", "🔧 New IT ticket · stand", "📦 Ready to verify · stand".

## 2026-10-01-ui-1
- **Warehouse Manager / Supervisor home redesigned.** It now has:
  - **"Hi Will 👋"** greeting and role in place of the name card;
  - a slim alerts chip;
  - **Right Now** cut to 4 numbers: Waiting · On the way · Overdue · To verify;
  - **two big cards for the jobs that need a person** — ✅ Approvals (now also counts deliveries waiting for a signature, and opens the right list) and 📦 Deliveries. Each turns maroon when something is waiting;
  - every other tool in a compact 3-across **Tools** grid: Create Transfer, All Transfers, Assign & Team, My Team, Golf Cart, Stand Report, Requests.
  The "First game" explainer box is gone.
- **Warehouse employee home:** "Hi Eli 👋 · 1 stand waiting", deliveries first, then two small side-by-side buttons (📷 Quick Drop · 🛺 Golf Cart) instead of two full-width bars above the list. No explainer box. Leaders don't get the duplicate Golf Cart button (it's in Tools).
- **Food Runner:** the "My coverage" box is now one line ("📍 My stands · 2 stands · Show all"), and the "1️⃣ Get the food…" hint line is removed. The button says what to do.
- **Alerts banner everywhere** is a slim chip ("🔕 Alerts blocked · Fix ›"). The green "alerts ON" banner is gone.
- **Golf Cart and Stand Transfer Report panes:** their explanation boxes are now one short muted line.
- **Manager / Support Manager / Supervisor:** the duplicate **Stand Chat** button is removed. The floating 💬 Chat button does the same thing and shows the unread count. Nothing else on those screens changed.

## 2026-10-01-chat-4
- **Chat request buttons cut to 4: 💵 Refund · 😠 Customer complaint · 🏷️ Comp / price · 🆘 SOS**, under "NEED A SUPERVISOR FOR…". Anything else, people just type. The stand side's quick-message row ("Need a Supervisor at the stand", etc.) is gone.
- **Requests show as cards:** a colored header ("💵 REFUND REQUEST"), who asked and their role, 📍 the stand, the typed detail, and the status (⏳ Waiting for a reply → 🏃 Sue is on the way → ✅ Handled by Sue). Supervisors and Managers get **🏃 On my way** / **✅ Done** buttons right on the card, which reply to the person who asked. Replies show as "↩ Re: Refund request".
- **Chat layout:** received messages on the left with the sender's initials (colored by role), name and role; yours on the right; consecutive messages grouped; small times; a "Today" divider.
- **Warehouse Leaders group:** the member/alert box and alert line are gone. Every message needs a stand: "📍 Which stand? (required)" with a searchable list ("229" finds 229 Sun Devil Burger & Tenders). The stand shows as a tag on the message and in the alert ("🏭 Warehouse · 229 Sun Devil…").
- **My Team cards:** initials circle, name, role and shift, a status pill (Working / On break / Not arrived / Absent / Checked out) with a matching colored edge, "🟢 In 4:02 PM · ⏹ Out —", one large main button (✓ Check in / ⏹ Check out / ✓ Back from break), and smaller buttons for Absent, Break, Move and Feedback.

## 2026-10-01-alerts-2
- **Managers are only alerted for things that need a manager, and only on days they've signed in.** A new `on_duty` table records who opened the app each game day (it cleans itself up after 30 days). "Managers" in alerts now means managers signed in today, so a test on a weekday no longer buzzes every manager's phone.
  - **No longer alerts managers:**
    - every new stock request ("Stock request in your coverage");
    - every new IT ticket;
    - every new stock request to warehouse leaders when the stand already has an assigned warehouse person;
    - every late food order (that was all managers and admins);
    - golf-cart flags (warehouse leaders still get them);
    - every new food order to Food Managers when a runner already took it (they're alerted only when no runner covers the stand).
  - **Still alerts managers (on-duty ones):** a chat message sent to Managers, an unanswered request escalated to Managers, a refund at a stand with no supervisor, an inventory reminder for a stand with no lead or supervisor, and late orders for a manager's own coverage area.
  - **Refund alerts bug:** the alert looked up supervisors using a schedule column that doesn't exist, so it always alerted every manager. It now goes to the stand's Supervisor (same rules as chat, including Admin pins).
  - **Late-order alerts sent once:** each open manager, supervisor or warehouse phone used to send the same late-order alert. Now only one phone sends it.
  - **Clearer alert titles:** `⏰ LATE · Stock · 207…`, `⏰ LATE · Food · …`, `💵 REFUND · stand`, `🙋 REFUND · stand` (chat request), `💬 Message · stand`, `🏭 Warehouse Leaders`.
- **Chat:**
  - **Clearer "Send to":** the choices show the person ("🧭 Sue (Supervisor)", "👔 Mia (Manager)"), with a line under them saying exactly who will be alerted ("🔔 Only Sue Qasuper will get an alert", or "🔕 No manager has signed in today").
  - **Quick requests** for things only a Supervisor or Manager can do: 💵 Refund, ❌ Void / wrong order, 💰 Cash drop / change, 🏷️ Comp / price, 😠 Guest complaint, 🔑 Manager override, 🧹 Spill / cleanup, 🆘 Supervisor now. One tap sends a highlighted "🙋 REQUEST" to the Supervisor (or the Managers if there's none). If nobody answers in 3 minutes, a **⬆ No answer yet — send to Managers** button appears.
  - Supervisors and managers get a "✅ Done" quick reply; managers also get "Approved".
  - The "Manager" line in each stand shows who is on duty. The 14-day footer is gone.
- **🏭 Warehouse Leaders group chat** for Warehouse Managers and Warehouse Supervisors, opened from the floating 💬 button. It shows who is signed in (🟢), and a message alerts the other leaders who are signed in today. Stand managers don't see it.
- **My Team check in / check out.** Each person shows "🟢 In 4:02 PM · still here" or "· ⏹ Out 10:15 PM". The bare icons are now labelled buttons: ✓ Check in, ⏹ Check out, ☕ Break, ✓ Back from break, ↩ Back on shift, ✕ Absent, ↩ Undo absent, ↔ Move, ⭐ Feedback. Check out is pre-filled with "End of shift", so it's one tap and OK.

## 2026-09-30-chat-3
- **Admin → "💬 Chat — who answers each stand".** Every stand at every venue is listed with who answers it today: ⭐ Stand Lead, 🧭 Supervisor, 👔 Manager.
  - **Automatic by default**, worked out from the schedule: the stand's lead, or the lead scheduled at its area such as "West Portables"; the supervisor scheduled at the stand or its area; all managers. A Stand Lead given multi-stand coverage in "Temporary Stand Lead → Multi-Stand Coverage" also counts as lead for those stands.
  - **Pin a person:** tap a stand to pick a Stand Lead (today's scheduled Stand Leads), Supervisor (today's scheduled supervisors) or Manager, or leave it "Automatic". "Use for every stand in this area" applies the pick to the whole area. A pinned person replaces the automatic people for that level, so only they get that stand's messages. A pin on one stand beats a pin on its area. "📌 set by Admin" shows in the stand's chat.
  - **Pinned Stand Leads:** a lead pinned to other stands gets those stands in their chat list. A worker pinned as Stand Lead gets chat as a lead.
  - **Storage:** pins are saved in `game_day_assignments` (team `stand_lead`, or `support` with role supervisor/manager). Managers placed on areas in the Coverage Plan now count as that stand's Manager, not its Supervisor. No database change.

## 2026-09-30-chat-2
- **"Who has alerts on" is Admin only.** It's gone from the Manager, Support Manager and Supervisor screens, and the screen itself refuses anyone but Admin.
- **Chat follows the chain of command.** There is still one conversation per stand per game day, so the stand name is always the thread title and leads every alert ("💬 205P Bar S Sausage"). Four levels:
  - **Stand crew:** people running a portable with no Stand Lead there, and NPO members.
  - **Stand Lead:** the stand's lead or NPO Lead, or the lead scheduled at an area like "West Portables", who covers every stand in that area.
  - **Supervisor:** coverage, scheduled at the stand, or scheduled at its area.
  - **Manager:** Managers and Admin.
- **One level gets each alert.** Every message has a **TO** choice: crew → Stand Lead / Supervisor; Stand Lead → crew / Supervisor / Manager; Supervisor → crew / Stand Lead / Manager; Manager → any. Only the chosen level is alerted (one lead over 5–6 portables gets only their portables' messages). The default is the next level, and replies go back to whoever wrote last. If nobody is on at the chosen level, the message moves up one level and the sender is told.
- **Who is on this stand:** each conversation shows the crew, Stand Lead (and their area) and Supervisor for that stand. Every bubble shows who sent it and who it was for ("Pam Qaport · Stand crew → Stand Lead").
- **Lists:**
  - A lead over several portables gets a list of their stands, with 🔴 New for you on top.
  - Supervisors and Managers see today's conversations plus "Message any stand".
  - Unread counts only include messages sent to your level.
- **Floating 💬 Chat button:**
  - Now shows for crew, leads, supervisors and managers. The Manager home no longer hides it, and it's hidden on the chat screen itself.
  - The unread count pulses.
  - A new message while the app is open shows a banner naming the stand, and tapping it opens that conversation.
  - Opening the app runs a check straight away.
- Names show as "First Last".
- DB: `stand_chat.sender_level` and `stand_chat.to_level` added (migration `stand_chat_levels`, optional columns — older builds keep working).

## 2026-09-30-team-2
- **Every stand at every venue** in Chat → "Message a stand" and in Assign & Team: all Mountain America stands, plus DFA 111/143/191 and Sun Devil Soccer Stadium, grouped by venue (DFA Warehouse and inactive stands are left out). Before, both lists only showed stands on today's schedule. In Chat, stands with a lead on today are listed first and marked "lead on today".
- **DFA and Soccer requests reach the right warehouse person.** Stock-request routing only looked at assignments saved under the stand's own venue, but Assign & Team saves everything on one row, so a DFA stand assigned in Assign & Team never routed. Routing now checks every venue and compares stand names consistently.
- Warehouse coverage uses the game day, not the calendar day, so assignments keep working after midnight.

## 2026-09-30-team-1
- **Sign-in forgives sloppy names.** The ID digits are still required, but the name only has to be recognisably the person: any capitals or spacing, accents, "First Last" or "Last, First", the first 3+ letters of the last name ("Bent", "Gaona"), one word of a two-word last name ("Cazares", "Gampler"), one typo ("Bently"), or the first name alone when that's the only match. One or two letters are still rejected, and if two people match it asks for the full last name. This covers workers, warehouse (60000), managers (90000), premium (70000) and food staff.
- **Warehouse Supervisor has every Warehouse Manager power** and still shows **WAREHOUSE SUPERVISOR** in the header. Two leftover manager-only checks were fixed: revoking or restoring golf-cart drivers and uploading the warehouse roster (the button was showing, but the action said "Not authorized").
- **Assign & Team rebuilt for a big crew.**
  - Top row: No stands / Assigned / Working today.
  - A search box, then everyone as a card, grouped as "Working today — no stands yet" first, then assigned. People not on today's roster are tucked behind a button.
  - Tapping a person opens their areas and stands right under their card; area chips show how many people already cover that area.
  - **📋 Copy last game's plan** gives everyone the same areas and stands as the last game in one tap.
- **Every stadium stand is listed** in Assign & Team. It used to list only stands on today's schedule, so a small schedule showed 2 stands.
- Create Transfer → Assign to: people on today's roster are listed first.

## 2026-09-30-food-2
- **Food orders now run by themselves, like the warehouse.** The Food Manager gives each runner their stands once, and every order from those stands goes straight to that runner. The manager doesn't have to press anything per order.
  - **Food Manager** has two tabs: **🍽️ Orders** and **👥 Assign Runners**.
    - Orders is watch-only. Right Now shows *No runner / Waiting / On the way / Late / Delivered*, and tapping a number filters the list.
    - The list is grouped into 🔴 No runner — pick one, ⚠️ Slow (a runner hasn't left after 10 min), ⏳ Waiting for the runner, and 🏃 On the way.
    - The only action is **↔ Change runner**. The old runner gets an "Order moved" alert, the new one gets the order.
    - The Start cooking / Food ready buttons are gone.
  - **Assign Runners** lists every runner with their stands (or "No stands yet"). Tap one to edit their areas or stands, **Save stands**, or **Take this runner off all stands**.
  - **Food Runner** opens on **My Jobs**. Each order has one button at a time: **🏃 On my way** (the stand is told), then **✅ Delivered to Stand** (the stand is told and the manager sees it under Delivered). Runners no longer wait for the manager to mark food ready. The runner stats box is gone; the tab counts show the same thing.
  - The food screens only show orders from the current game (last 18 h). Seven orders left open since the Sept 6 game no longer clutter the list.

## 2026-09-30-food-1
- **Food Manager screen redesigned — one clean list, nothing in the way.** Removed the profile card, the single "Orders" tab bar, the coverage banner and the long runner explainers.
  - **Right Now** strip at the top: Need runner / To cook / Ready / On the way / Late. Tap a number to show only those orders; tap it again (or "show all") to see everything. **👥 Runner Areas** sits next to it.
  - Orders are grouped in the order the manager acts on them: 🔴 Needs a runner → 👨‍🍳 To cook → ✅ Ready for pickup → 🏃 On the way.
  - Each card shows the stand, time left (red when late), items, the runner and status, and **one** button ("👨‍🍳 Start cooking" or "✅ Food ready — tell the runner"). The runner dropdown is hidden behind "Change runner" and only opens by itself when nobody is assigned.
- Food Runner screen unchanged apart from the shorter coverage card.

## 2026-09-30-alerts-1
- **Game-day alerts screen.** Phones only show the "Allow notifications" prompt after a real tap — the old automatic request 1.5 s after sign-in was ignored or silently blocked by iPhone and newer Android Chrome. After sign-in, leaders, supervisors, warehouse, food, IT and managers (not regular workers) now get one screen per day until alerts are on:
  - not asked yet → one big **🔔 Turn on alerts** button (a real tap, so the phone's Allow prompt appears);
  - blocked → step-by-step unblock instructions for iPhone / Android / computer, then "check again";
  - iPhone in Safari → **Add to Home Screen** steps (iPhone only delivers alerts to the Home Screen app);
  - on → **📲 Send me a test alert** to prove it end to end.
  The 🔕 bell and every "Notifications blocked" banner now open the same screen.
- **"Who has alerts on"** for Managers and Supervisors: today's Stand Leads, NPO Leads, people running portable stands, supervisors, warehouse, food, IT and managers, with ❌ / ✅ from `push_subscriptions`, so someone can walk over and fix it before gates open.
- **Supervisors scheduled at an area** ("West Portables") now start on a real stand in that area, with "Your area: West Portables (14 stands). Pick the stand you are at." The area's stands also count as their My Stands (Stand Status, chat).
- **IT tells the stand:** the Stand Lead / NPO Lead / people running the stand get "🔧 IT is on the way" when a tech claims the ticket and "✅ IT issue fixed" when it's resolved.
- Long overdue times read in hours ("3h 21m overdue" instead of "201m").

## 2026-09-30-warehouse-2
- **Warehouse Supervisor now has the Warehouse Manager's full access** and the same home screen: Right Now strip, Approvals, Deliveries, All Transfers, Create Transfer, Assign & Team, My Team, Golf Cart (driver approvals + "needs review" + Mark repaired), Stand Transfer Report, roster upload, and request history.
- **Sign-off is one step: "Verify & approve".** Any leader who could sign could also approve right after, so the second tap added no second person. The old separate Approve button still works for anything already verified. A leader may sign off their own delivery; the screen says so and every other leader gets a push ("… signed off their own delivery"). Every sign-off notifies the other leaders.
- **Golf cart: "🔧 Report a cart problem"** on the key board for every warehouse role (employee, supervisor, manager — same buttons). Pick the cart, say what's wrong; an available cart goes out of service at once, managers and supervisors get a push, and it appears under "needs review" until a leader taps "Mark repaired & back in service".
- **NPO Group Sign-in is a full-size button** right under the main Sign in (was a small text link at the bottom).
- Warehouse refresh back to every **10 s** (the shared download from warehouse-1 keeps it at 12 requests/min, down from 18).

## 2026-09-30-warehouse-1
Warehouse Manager / Supervisor / Employee — faster, simpler screens.
- **Less than half the network traffic.** Each warehouse phone made 18 requests a minute (up to 150 transfers downloaded twice every 10 s, plus a separate stock-request query for the manager list). Now one shared download per refresh (`whOpenTransfers`, cleared on any write so lists never go stale), only the list on screen is rebuilt, refresh every 15 s, and no refresh while the phone is locked: **8 requests a minute** for all three roles.
- **"Right now" strip** on Manager and Supervisor home: Waiting · On the way · Overdue · To verify · To approve (+ Unassigned for the manager). Each number opens the right list. Built from data already loaded — no extra requests.
- **Supervisor home:** *Deliveries* (the same stand-by-stand list employees use, all stands, delivery work only) and *Sign-offs* (only what waits on their signature/approval) replace the old Transfers / Requests tiles, which showed the same work twice. Request history and "new request for a stand" are one tap below. Tiles show live counts ("1 to sign", "2 requested · 1 transfer").
- **Manager home:** tiles in order of use — Approvals (turns red when something waits), All Transfers ("1 to sign" etc.), Create Transfer, Assign & Team, My Team, Golf Cart, Stand Transfer Report. The All Transfers list takes today's stand requests from data already loaded instead of a second query.
- **Employee cards** show what to bring (the requested items) and an **ASSIGNED TO YOU** tag on transfers the manager assigned to them; assigned work sorts to the top. Finished stands leave the list immediately.
- Leaders' "Deliveries" list no longer includes finished or waiting-for-signature transfers.
- First-game tips updated to the new tiles; header shows "Auto-refresh 15s".

## 2026-09-30-qa-fixes-1
Fixes from the simulated game-day QA run (report: "Stadium Ops Game-Day QA Report").
- **Stock requests save on the first try again, with their ETA.** The `client_uuid` unique indexes were *partial* (`WHERE client_uuid IS NOT NULL`), which Postgres/PostgREST cannot use for `on_conflict`, so every stock request failed twice and only saved through a fallback that fired because the regex `/eta/` matched the word "d**eta**ils" in the error JSON — and that fallback stripped `eta_deadline`/`eta_minutes`. Migration `qa_fixes_client_uuid_active_sessions_roster_phone` replaces them with plain unique constraints on `stock_requests`, `kitchen_requests`, `transfers` and `stock_ledger` (NULLs still allowed). Fallbacks now test `sbErrText(r)` (the error's message/details/hint) instead of the raw response body. Food requests and ledger writes now upsert on `client_uuid`, so a weak-WiFi retry returns the row already saved instead of a duplicate.
- **"Already being counted by X" warning works for the first time.** `active_sessions` had row security on with no policy, so every read and write was refused silently (0 rows ever). Added the same open policy the other tables use.
- **Warehouse roster phone numbers removed.** They were never shown in the app but were readable with the public key. Existing numbers cleared, uploads no longer store them, row security turned on.
- **Login is stricter.**
  - Workers must type their full last name (letters only compared, so "Van Gampler" / "vangampler" both work); it used to accept any prefix — ID + one letter signed in.
  - Only today's schedule (or last night's game before 6 AM) can sign in. It used to fall back to the person's most recent schedule, so someone not working today landed on an old stand.
  - Warehouse (60000), Premium (70000), Manager/Support Manager and Food last-name logins no longer accept the first 3 letters of a last name.
- **Stands without a Stand Lead are covered.**
  - Inventory lock: at portable stands (and temporary / NPO self-access), whoever leaves **last** must finish Count Out; earlier leavers see "N others still working here — whoever leaves last must finish Count Out".
  - Stand Chat is open to anyone running a stand with lead tools (shown as "Stand staff").
  - Inventory Tracker / reminders / chat pushes now include the people running stands with no Stand Lead; a reminder that would reach nobody goes to managers. Tracker label: "No Stand Lead — Supervisor responsible".

## 2026-09-30-inventory-chat-1
- **Stand Leads can't leave the stand until inventory is done.** "Leave this stand" for a Stand Lead or NPO Lead is locked until that stand's **Count In and Count Out** are both submitted today; the message offers a button straight into the missing count. Regular workers, students, bartenders with temporary lead access and NPO members are not affected. Stands with no stand sheet are never locked. Pay clock-out is still the Kronos clock — this is the "done at my stand" step.
  - **Override:** a Supervisor or Manager can still clock a lead out (sick, emergency) after a warning; the attendance note records `[INVENTORY OVERRIDE — missing …]` under their name. A Stand Lead cannot clock out another Stand Lead while inventory is missing.
  - If the app can't reach the server, the lead can still leave after a warning — the Manager tracker shows the gap.
- **Inventory Tracker** (Manager + Supervisor home): Count In X/Y and Count Out X/Y for today's stands, "Missing Count Out / Missing Count In / All" filters, the Stand Lead / NPO Lead name per stand, **🔔 Remind** per stand and **Remind every stand shown** (push to the leads and the stand's Supervisors), a shortcut to open the missing count, and a list of lead overrides.
- **Stand Chat** replaces phone calls between Stand Leads / NPO Leads and Supervisors. One conversation per stand per game day. The stand side sends to the Supervisors assigned to that stand (Admin Coverage + scheduled supervisors); if none, to Managers. Managers see and reply to every stand, and can download a day's chat as CSV. Push notification on every message, unread badge on the floating button, quick-message buttons, messages checked every 5 s only while a conversation is open (no Realtime connections). Messages delete automatically after 14 days (pg_cron job). The floating 📞 button becomes 💬 Chat for these roles; emergency numbers stay inside it. Everyone else keeps 📞 Contacts.
- DB: new table `stand_chat`, view `stand_sheet_stands`, cron job `stand_chat_cleanup_14d` (migration `stand_chat_and_inventory_tracker`).

## 2026-09-29-food-stands-1
- **Food Manager → Runner Areas now also works by individual stand.** Pick whole areas (tap again to remove all of them), or tap single stands using the new filter box. Area buttons light up only when every stand in the area is selected; a "N selected" count shows the total. "Today's Food coverage" lists full areas plus any extra individual stands. Data is unchanged (`kitchen_runner_assignments.stands`), so existing assignments load as-is.

## 2026-09-29-cart-questions-1
- **Golf cart safety questions, rebuilt to the managers' actual rule.** Every take and every return is now checked with real questions, answered one by one (OK or Issue) — no all-good shortcut buttons (I had added two by mistake, "✓ All good" and "Mark all 12 OK"; both removed):
  - **First person on a cart each day, taking it:** the full **12 questions** (unchanged).
  - **Every later person taking that same cart that day:** **4 questions** — Brakes work · Tires & steering good · No new damage or fluid leaks · Lights, horn & seatbelt work.
  - **Returning a key (everyone):** the same **4 questions**, required. "Return Key N" opens them; the button stays until all 4 are answered, and a description is required if anything is an Issue.
  - Any Issue (at take or return) takes the cart out of service, logs it for the Manager's "needs review" list (cleared with "Mark repaired & back in service") and notifies managers. At pick-up the key is not handed over.
- Every check is recorded (who, when, each answer, type: full / quick / return). Only a clean **full** inspection counts as "first use done" for the day — quick and return records don't, so the first driver of the day always gets the 12.
- The key board says "First use today · 12 questions" or "✓ Inspected today · 4 questions". After taking or returning a key you're sent straight back to your home screen with a notice.
- Tested end to end in a headless browser (18 checks).

## 2026-09-29-cart-return-ui-1
Found by the user testing the previous golf cart build on a phone.
- **"Check out" is gone from the golf cart flow — it read like attendance's Check out.** The cart now says **take** and **return**: "✓ All good — take Key 1", "Submit inspection & take the key", "🟡 You have this — tap to return", "🔴 In use", "Key 1 is yours — collect it from your Manager or the Warehouse Manager".
- **The return buttons now look and work like buttons.** They were outlined/notice-style (read as text, and the options appeared off-screen below the keys, so tapping "Return Key" seemed to do nothing). The return block now sits **above** the keys with solid colored buttons: 🔑 Return Key N (red), ✓ No problems — return key (green), ⚠️ Report an issue (orange), and it scrolls the options into view.
- **Tapping the tile of the key you're holding now starts the return** (it looked tappable but did nothing). Other people's keys say "In use" and are visibly not tappable.
- **Returning always asks first**, with "return" wording (not "drop key"): "Return Key N? — Hand the key back to your Manager or the Warehouse Manager. [Not yet] [Yes, return key]"; reporting an issue asks "Report the issue and return Key N?". After it goes through you're taken back to your home screen with a "✅ Key N returned — thank you!" notice.
- **The full first-of-the-day inspection is no longer 12 separate taps:** a green **✓ Mark all 12 OK** button at the top ticks everything, then tap Issue on anything that isn't right.
- Tested in a headless browser (18 new checks + the earlier 17 + 14 + 8, all passing).

## 2026-09-29-cart-no-hold-1
- **Golf cart: nobody is held on the cart page anymore, per direct request — drivers have warehouse work to do.** Checking out a key (from either the quick check or the full inspection) now sends the person straight back to their own home screen (the warehouse page for warehouse staff) the instant the key is checked out. The "collect your key from your Manager or the Warehouse Manager" reminder stays up for 8 seconds as a notice on the home screen instead of a separate confirmation page. (It used to show a confirmation page for ~3.5 s first.) Returning a key already went straight back and still does. Only a reported problem keeps you on the key board, since you then need to pick a different cart.

## 2026-09-29-cart-quick-check-1
- **Golf cart: every pick-up now gets checked, without a big form, per the managers' request.** A cart can be fine at 8am and broken by 2pm, so once-a-day wasn't enough — but making everyone do 12 items every time means nobody does it properly. Now: the **first driver on a cart each day** does the full 12-item inspection (unchanged); **every driver after that** gets a **quick check** — the cart number, who returned it last and when, three chips (🛑 Brakes · 🛞 Tires & steering · 🔧 No damage or leaks), one big **✓ All good — check out** button and a red **⚠️ Something's wrong**. "Something's wrong" asks what (tap Brakes / Tires-steering / Damage-leaks / Other) and requires a description.
- **Reporting a problem now really takes the cart out of service.** A quick-check issue, and a failed full inspection, mark the key **out of service** and log it in the Manager's "needs review" list, so the Manager can clear it with **Mark repaired & back in service**. (Before, a failed full inspection only blocked the cart for the rest of the day with no way to clear it.) Managers are notified.
- **Every pick-up is recorded** (who, when, all-good or issue) in the same inspections table. The key board says "✓ Inspected today · 5-sec check" or "First use today · full inspection".
- **Returning a key is one tap:** "No issues — drop key, done" no longer asks a second confirm; reporting an issue still asks first. Returns already ask "any issues?", so the driver who just used the cart is the second safety net.
- Tested in a headless browser: first use → full form; later driver → quick check; All good → recorded + key checked out; Something's wrong → blocked until something is picked and described, then flags the cart and logs it for review; key-board badges; one-tap return.

## 2026-09-29-wh-checkin-checkout-1
- **Warehouse My Team (Supervisor + Manager) now has real Check in and Check out, not present/absent, per direct correction.** Each person has two labeled buttons — **✓ Check in** and **⏹ Check out** — plus ⭐ feedback, instead of the bare ✓ / ✕ icons. The row shows the actual times in Phoenix time: "Checked in 8:05 AM", then "Checked out 1:00 PM · in 8:10 AM", with the scheduled shift on its own line. Check out is greyed until the person is checked in (and tapping it early says to check them in first); checking in again after a check-out starts a new session. The counter reads "N checked in · N checked out · N scheduled". The ✕ Absent button is gone. Tested with sample attendance data.

## 2026-09-29-wh-audit-cart-dialogs-1
Found by a full warehouse-department recheck (code audit + live database checks + a headless-browser smoke test of the new code, 14 checks passing).
- **Golf cart: popups fixed.** The dark native browser popups ("asu-aramark.netlify.app says…") are replaced with the app's own readable dialog. Inspection is now one action — the safety acknowledgement is printed above the button and **"Submit inspection & check out"** does both, so there is no second popup sitting on top of a "Saving…" button. The Comments box is bigger (16px text, solid border), scrolls itself into view when tapped, and turns red and jumps into view the moment any item is marked Issue. Flagged-cart and return popups are readable too.
- **Golf cart: automatic trip home.** After a key is checked out or returned, the app takes the person to their own home screen once, by itself (checkout shows the confirmation for ~3.5 s first). The button is still there ("Back to home now") but nobody has to keep tapping.
- **Golf cart rules, confirmed from the code:** the pre-use inspection is once per cart per day (later drivers that day just confirm); the license/policy verification is once per driver per season.
- **Real bug: Manager could not assign a transfer to the Supervisor at all.** The Assign-to picker reads `warehouse_employee_directory`, a view that only listed `warehouse_employee`. The view now includes `warehouse_supervisor` (picker labels them "(Supervisor)").
- **Real bug: push notifications never re-linked a phone to a new login.** A device's subscription was only saved the moment permission was first granted, under whoever was logged in then. Live data: the active Warehouse Manager, the Warehouse Supervisor and every current warehouse login had zero subscriptions. Every login now re-links the device to the person signed in (`syncPushSubscriptionIdentity`). People must open the app once after this deploy for it to take effect.
- **Supervisor transfers, no longer one mixed list:** the Transfers list now groups by what needs *you*: "Needs your signature", "Assigned to you — deliver these", "Signed — ready for your approval", then everything else. The tile says the same in words ("1 to sign · 1 for you · 1 to approve").
- **Separation of duties:** a Supervisor can no longer sign off or approve a delivery he made himself (he could deliver, verify and approve his own transfer with nobody else looking). Those go to the Warehouse Manager; the "ready to verify" alert skips him and falls back to the Manager. Manager's one-tap self-handled shortcut is unchanged.
- **Notification gaps closed:** a new stock request now also alerts the Supervisor and Warehouse Manager when the stand has coverage (before, only the routed people heard); "signed — ready for approval" now also alerts Supervisors, not just Managers.
- **Pane switching hardened:** opening any warehouse tile no longer depends on a hidden tab element existing (that dependency caused the wrong pane to show under "My Team" and "Golf Cart" titles).
- Supervisor's My Team always reads today's date fresh (a phone left open overnight no longer shows yesterday). "Send back" now uses a readable in-app text box instead of the native prompt, and is gated in the function itself; feedback save and two confirm popups (remove item, confirm transfer received) use the readable dialog.

## 2026-09-29-myteam-date-fix-cart-id-1
- **Real bug fix, found by screenshot: the scheduled shift time was getting silently cut off ("Scheduled 08:00 AM–...")** — the status and schedule text were sharing one `.prem-row-meta` line, and that class is nowrap+ellipsis everywhere else in the app. Split onto two separate lines so neither truncates.
- **Real change, per direct correction: Supervisor's My Team no longer has a date picker at all — always today, no way to accidentally land on the wrong day.** Manager keeps the date picker unchanged (useful for prepping a future day's roster ahead of time). Today is still resolved via `localISODate()`, which already correctly uses America/Phoenix rather than the browser's own timezone or raw UTC.
- **Real, structural discovery while setting up test data for Golf Cart: a warehouse person's daily roster CSV "ID" and their actual login ID (`staff_accounts.employee_id`) are two completely different numbers in this org's data.** Confirmed directly: Bentley, Flenard's roster CSV ID is `32278100`; his real staff login ID is `87360000`. The Golf Cart driver-approval form asks for "Employee ID (last 5 digits)" — if a Manager reads that ID off the daily roster export instead of the person's actual login ID, the approval silently never matches when that person tries to check out a key (found exactly this: a leftover driver record used the roster ID and could never have worked). Fixed for this test case (activated the correct login-ID record, removed the incorrect roster-ID one) — worth deciding whether the driver-approval form should say "the ID they log into the app with" more explicitly, since roster ID and login ID being different numbers isn't obvious at a glance.

## 2026-09-29-sup-cart-simplify-1
- **Real simplification, per direct correction: Supervisor's Golf Cart access stripped down to exactly what he needs.** He's an approved driver like anyone else on the list — not an admin over it. His tile now goes straight to the checkout/return-a-key screen; the driver list, "Cart Duty — Today," self-service request, and flagged-cart review are all gone from his side, Manager-only. Removed the now-dead self-service functions (`whCartSelfServiceRender`, `whSupSelfApproveCart`) and simplified `adminLoadDrivers`/`adminToggleDriver`/`whBuildCartPane` back to a single Manager-only path instead of branching per role.

## 2026-09-29-sup-cart-checkout-transfer-fix-1
- **Real gap fixed, per direct question: "if Warehouse Supervisor wants to use the golf cart himself, how does he?" — he couldn't.** Supervisor's Golf Cart tile only ever opened the monitor/admin pane (driver list, cart duty, self-approve his own driver record) — the actual physical key checkout screen only had an entry point on Employee's own delivery screen. Added the same "Check out / return a key yourself" button to Supervisor's (and Manager's) Golf Cart pane — same destination, same existing approved-driver gate, so anyone not on the list still gets blocked there exactly as before.
- **Real gap fixed, per direct question: "if Manager assigns a transfer to Supervisor, how does he check and complete it?"** He could already tap into it and complete the whole thing — that part worked — but the row just showed a plain "✓ Assigned to you" text label with no visible way to act, easy to read as "someone else is handling this." Still-in-progress rows assigned to you now show an actual "▶ Continue delivery" button.
- **Real inconsistency found while checking that: the list-view "✅ Approve" button (`whConfirmTask`) was never updated when Supervisor got final-approval authority — it was still Manager-only, and the function itself had zero role check at all**, unlike `whFinalApprove()` (the transfer-detail screen's identical action), which got both the access change and the gate. Fixed to match: Supervisor can approve from either screen now, both are gated in the function itself, and the Manager gets the same "approved without you" notification either way.
- **Removed Stand Transfer Report from Supervisor, per direct correction — Manager only, no exceptions.** (Previously reasoned as low-risk since it's read-only; overridden by direct instruction.)

## 2026-09-29-myteam-tab-fix-mgr-only-upload-1
- **Real bug fix, found by a live screenshot: tapping "My Team" showed the Requests screen underneath a "My Team" title.** `whMgrOpenPane('roster')` looks up a hidden tab-bar element (`wh-tab-`+mode) to hand off to `whMode()`, the function that actually switches which pane is visible — Inventory and Golf Cart both had one of these (hidden, tile-only access), but My Team never got one when it was added. That silently skipped the whMode() call entirely, so the title bar updated correctly but the pane content stayed whatever was open before — Requests, in the reported case. Added the missing `wh-tab-roster` element; opening My Team now actually shows My Team.
- **Real change, per direct request: Supervisor's My Team no longer has an upload card at all — upload is Manager (and Admin, from its own screen) only.** Supervisor still gets the full check-in/absent/feedback list, just no way to upload or replace the roster CSV. The upload function itself checks this now too, not just the missing button.

## 2026-09-29-sup-final-approval-1
- **Real change, per direct request: a verified transfer used to sit stuck waiting for final approval whenever the Warehouse Manager wasn't around to do it — no toggle, no away-state, just give Supervisor the authority to finish it themself.** Supervisor now sees the same "✅ Approve" step Manager always had, once sign-off is done — and the Warehouse Manager gets a push notification every time Supervisor completes one without him ("Supervisor approved a transfer — [name] approved [stand] without you"), so he stays aware even for approvals he didn't personally make. Manager's own approval is unchanged and silent (no need to notify himself).
- **Notification pipeline checked, not just assumed working:** the `send-push` edge function is deployed and active, with a real CORS fix already in its history (documented in its own source — the reason nothing worked from inside the app while a manual curl test worked fine). 54 of 71 staff-tier accounts (Manager/Warehouse/Food/IT/Admin — not the 400+ regular workers, who don't use push) currently hold a live push subscription, and dead subscriptions clean themselves up automatically on every send. Could not pull today's actual delivery success/failure logs from this session (log query backend errored) — that still needs a live phone test to confirm real-time delivery, not just that the pipe itself is correctly built.

## 2026-09-29-wh-myteam-permission-gates-1
- **Real fix, found auditing the last two builds' new functions against this app's own hard-won rule ("hiding a button isn't the same as blocking the action"):** `adminToggleDriver` (approve/revoke a cart driver), `whSupSelfApproveCart` (Supervisor's self-service cart request), `whRosterCheckIn`/`whRosterMarkAbsent` (My Team check-in), and `adminUploadWarehouseRoster` all had zero role check in the function itself — only the button calling them was hidden from the wrong role. Any signed-in warehouse session could have called them directly (e.g. from devtools) regardless of role, the same class of gap `whFinalApprove` had before it was fixed. All five now check the caller's actual role before doing anything: Warehouse Employee is locked out of all of them; Supervisor can toggle only their own cart-driver record, never someone else's; Manager/plain Admin keep full authority.

## 2026-09-29-wh-myteam-rename-admin-upload-1
- **Real fix, per direct report: "I'm not seeing Warehouse Supervisor's My Team — no one" — it existed, it just wasn't called that.** The tile shipped last build as "Warehouse Roster"; renamed to "My Team" everywhere (tile label, pane title) to match Stand Lead/Supervisor's own screen naming, and moved up to sit right after Requests (Supervisor) / All Transfers (Manager) instead of at the end of the grid — same "near the top, not buried" spot every other role's own team screen gets.
- **Real feature, per direct request: each person's row now shows "Scheduled 08:00 AM–04:00 PM"** straight from the uploaded roster's Start Time/End Time columns, next to their check-in status — the whole reason Manager/Supervisor need this screen is to know who's actually supposed to be there and when, not just a name list.
- **New: Admin can also upload the warehouse roster CSV**, per direct request — same upload, same `warehouse_roster` table, new card on the Admin screen (next to the existing ReadyOn schedule upload) so it's not only reachable from inside Warehouse Manager/Supervisor's own screen.
- Confirmed already correct, no change needed: Warehouse Manager already had the exact same upload/check-in access as Supervisor — same shared pane, nothing Supervisor-only about it.

## 2026-09-29-wh-roster-cart-monitor-1
- **New: Warehouse Roster check-in/out, per direct request.** With 400+ warehouse staff, Supervisor/Manager can't clock people in one at a time by hunting down individual employee IDs. New "👥 Warehouse Roster" tile (Manager + Supervisor) uploads the daily warehouse roster CSV export (same "Date: MM/DD/YYYY / Department: Warehouse" format used for scheduling) into a new `warehouse_roster` table, scoped strictly to warehouse staff for that date — never the full building roster. Uploading again for the same date replaces it, it never piles on top. The check-in list itself is the same "leader checks their own people in, not self-report" pattern as My Team/Team Control: instant ✓ check-in / ✕ mark-absent per person, a progress count, search by name, and inline ⭐ feedback — reusing the existing `attendance` and `worker_feedback` tables, no new ones needed for that part.
- **Golf Cart access split, per direct correction: Supervisor was given the exact same approve/revoke authority as Manager — that was wrong.** Supervisor's cart pane is now monitor-only: sees the full driver list and who currently holds a key, but can't approve or revoke anyone else's access. The one exception is their own record — Supervisor can request and self-approve their own cart access (and give it up again), with the Warehouse Manager notified either way so nobody's driving without the Manager knowing. Manager keeps full authority over every driver, unchanged, plus everything Supervisor now has.
- Confirmed already correct, no change needed: Golf Cart checkout already blocks anyone not on the approved-driver list (`cart_drivers`) from actually using a key — the gate was already in the checkout flow itself (`gc-blocked-section`), not just the button that opens it.
- Confirmed already correct, no change needed: the Supervisor's name shown under a stand's delivery screen ("Bentley, Flenard" style) is just "who's currently operating this screen," not an assignee or e-sign field — reported as looking wrong mid-testing, traced to `ts-sub.textContent` showing the logged-in user's own name, same as it does for every role doing a delivery.
- Real, latent gap fixed in passing: opening the Golf Cart pane never actually loaded the flagged-returns list or today's Cart Duty log — only a driver-approval action did, after the fact. Both now load the moment the pane opens, like every other pane in this app already does.

## 2026-09-29-zonestands-coverage-fix-1
- **Real, live bug found by a full-codebase audit for the exact "two disconnected structures, one real-world fact" pattern that had already caused three other incidents this app (warehouse coverage tables, requests/transfers, back-button vs. swipe gesture).** `getMyZoneStandsCached()` — which powers the "My Stands vs. All Stands" toggle on the Stand Status and Transfer Record screens (Manager/Supervisor) — still read only the legacy `zone_assignments` table. Nothing writes to that table anymore (its admin form was removed when Assign & Team's unified coverage tool replaced it), so the toggle had been silently, permanently hidden for every Manager/Supervisor since that removal — even people with a real coverage assignment set through the current Admin Coverage tool had no way to see it, and no one would know unless they specifically went looking for a toggle that's supposed to be there.
- Fixed the same way the equivalent warehouse-side bug was already fixed: now checks `game_day_assignments` (team `support`, the key Admin Coverage's "Support / Managers" option writes) first, falling back to the legacy table only if nothing was ever migrated there. No behavior change for anyone without a coverage assignment — the toggle still stays hidden exactly as before.
- Full audit also re-verified the three previously-fixed instances of this pattern are still correctly fixed (warehouse coverage, Requests/Transfers merge for both Manager and Supervisor, the `BACK_MAP` typo) — no regressions found. One additional item flagged but left as-is: Golf Cart has no entry point on the Manager's own dashboard (`mgr-carts`), but unlike the original Golf Cart incident this is a clearly self-documented deliberate omission, not a silent orphan — worth a decision, not an automatic fix.

## 2026-09-29-cart-icon-duty-audit-1
- **Real bug fix:** every Golf Cart icon was 🛺 (auto rickshaw/tuk-tuk), not a golf cart. Replaced everywhere with the app's own existing custom golf-cart SVG icon (was already defined, just underused), or ⛳ where only plain text is possible (e.g. the pane back-bar title).
- **New: Cart Duty — Today**, per direct request. Warehouse Supervisor/Manager mark each approved driver in/out of cart duty themselves — same pattern as My Team's attendance (a Stand Lead/Supervisor marks their workers; workers don't self-report) — not a self-service action by the employee. Deliberately today-only, no date picker, so it can't become a retroactive record edited after the fact. Separate from the physical key checkout/return flow, which stays self-service for whoever's actually driving.
- **Access audit, grounded in real data where the data actually supports it:** checked actual transfer/assignment history in the live database — found only 1-2 real records exist total, nowhere near enough to learn real behavioral patterns from yet. Instead did a full structural audit of every place Manager/Supervisor permissions diverge in code. Confirmed the final-approval gate (Manager-only after Supervisor's own verify) is a deliberate, already-correct two-step accountability chain — left unchanged. Extended Stand Transfer Report (a pure read/export report, no approval authority) to Supervisor, same as Golf Cart — no real risk in it. Create Transfer and Assign & Team remain Manager-only for now — those are real planning-authority decisions, not simplifications, so flagging them for confirmation rather than changing unilaterally.

## 2026-09-28-golfcart-reenable-1
- **Golf Cart re-enabled, per direct request.** The full system — authorized-driver whitelist, license/policy verification, key checkout with a race-condition guard, return with issue-flagging, and repair-confirmation before a flagged cart goes back into service — was already fully built and had real production data in it (30 approved drivers, 4 keys), but had been switched off with no entry point. It's back:
  - Warehouse Manager and Warehouse Supervisor both now have a "🛺 Golf Cart" tile — driver approval and the flagged/needs-review list, exactly the same for both roles (was Manager-only).
  - Warehouse Employee gets a "🛺 Golf Cart — check out / return a key" button on their delivery screen — they had no way to reach the driver-facing checkout flow at all before this.
  - The flagged-issue return, which already takes a cart out of service and requires a manager/supervisor to mark it repaired before it's usable again, **is** the maintenance report — no separate system needed, it was just unreachable.
  - Cart notifications (a flagged return) now reach Warehouse Supervisor too, not just Warehouse Manager and the stand Manager.
  - The repair-confirmation log now records the real person who confirmed it, not a hardcoded placeholder — matters now that Supervisor can confirm it too, not just Manager.
  - Both tiles show a live "🚫 N flagged — needs review" badge, same at-a-glance pattern as the Approvals tile, so nobody has to open the pane just to check.

## 2026-09-28-merge-requests-transfers-1
- **Merged Requests into All Transfers for Warehouse Manager, per direct request.** A stand's stock request and a manager-created transfer are the same thing to deal with once work is moving (a fulfilled request literally becomes a transfers row) — the only real gap was the window before that happens, when a Pending/Claimed request has no transfer row yet and was invisible in All Transfers. That gap is closed: open requests now show as their own cards (📥 Stand requested, amber-flagged) right in the same All Transfers list, using their existing Start Delivery/Deliver Items actions — once a stand's real transfer exists, its card takes over and the request card steps aside instead of showing the same stand twice.
- The separate Requests tile is gone from the Warehouse Manager's screen — one list to check instead of two. Warehouse Employee and Supervisor keep their own Requests tab unchanged, since they use it differently (to find and claim their own work).

## 2026-09-28-coverage-owner-deterministic-1
- **Real fix, per direct instruction:** when 2+ people are assigned to cover the same stand, the auto-picked "route owner" for a new transfer used to be whichever row the database happened to return first — arbitrary, not something a manager could predict. Now it's deterministic: whoever was assigned to that stand first stays the consistent pick. Round-robin between multiple covering people is planned as a follow-up (deliberately not built yet), not an oversight — marked with a TODO in the code.

## 2026-09-28-food-autoroute-simplify-1
- **Real workflow fix, found by direct report: Food Manager was manually assigning a runner from a dropdown for every single order, all game, and stopped using the app because of it.** Root cause: a runner already assigned to cover a stand's area was only ever sent an informational "heads up" push — the actual assignment step was always left for the Food Manager to do by hand, no matter what. New food requests now auto-assign directly to that covering runner at submission (straight into their My Jobs, no claim step needed); the Food Manager still sees every order and can reassign any of them, but only needs to act on the ones genuinely unclaimed (no runner covers that stand yet).
- Food Manager's queue card replaced the always-visible runner dropdown with a compact status (🏃 Assigned: name, or 🔴 Unclaimed) plus a small ↔ reassign toggle that opens the dropdown only when tapped. Unclaimed orders now sort to the top so they're the first thing seen.

## 2026-09-28-myteam-buttons-polish-1
- **My Team's UI (Manager/Support Manager/Supervisor/Stand Lead all share this screen) restyled to match Team Control's polish**, per direct request that it looked "cheap" next to the new screen. Wordy full-width pill buttons ("✅ Mark present", "❌ Mark absent", "☕ Start break"...) are now the same round icon buttons (✓ ✕ ☕ ⏹ ↔ ⭐) as Team Control, with the same colored-left-border row style. No behavior changed — every existing rule for who can do what to whom is untouched, only the visual presentation.

## 2026-09-28-transfer-dedupe-fix-1
- **Real bug fix, found by live user report:** the `transfers` table had no duplicate-submission protection at all — unlike Stock and Kitchen requests, which both already use a stable per-form client id plus a database-level unique constraint. Repeated taps or a slow-network retry on Create Transfer could silently create multiple near-identical transfers for the same stand, which is exactly what was cluttering Approvals/All Transfers/the Stand Transfer Report with old, incomplete-looking entries. Added the same protection: a `client_uuid` column + unique index on `transfers`, and the Create Transfer form now generates one stable id per form-open, reused across retries, cleared only after a real success.
- Cleaned up the accumulated test transfers from today's testing (6 rows across 4 stands, all confirmed test/demo activity, not real game data) — Approvals and All Transfers are correctly empty again.

## 2026-09-28-teamcontrol-premium-1
- **Team Control's "All Stands" screen rebuilt to match Premium's Check-ins interface**, per direct request: individual worker rows with inline ✓ Present / ✕ Absent right in the list — no more tapping into a stand just to mark someone — collapsible per-stand groups, and CSV + PDF export (same clean printable style as every other export in this app).
- **Employee Stands and NPO Stands are now two clearly separate sections**, not mixed together. Employee rows keep the fuller action set (↔ Move, ⭐ Feedback, inline expand — no modals). NPO rows are intentionally simpler — Present/Absent only, since NPO placement is controlled by the group assignment, not this screen.
- All actions here are instant and optimistic, same pattern as My Team's recent update — tap it, see it update, syncs in the background.
- The old stand-summary-card view (tap through to My Team) is gone from this screen; My Team itself is unchanged and still reachable for anyone who wants the fuller single-stand view.

## 2026-09-28-backnav-noschedule-fix-1
- **Real bug fix, found by live user report:** swiping back (phone's native gesture) from My Team, after a Manager/Support Manager opened it from Team Control, landed on a random/wrong page instead of back on Team Control. The in-app ← button already knew to reopen Team Control (`reqScreenBack()`), but the phone gesture goes through a completely separate handler (`handleAppBack()`, via `popstate`) that never got the same fix — and a leftover typo in `BACK_MAP` (`screen-myteam` instead of the real `screen-my-team`) made the fallback route even less predictable. Both are fixed now: the gesture handler matches the in-app button's behavior, and the typo'd map entry is corrected so Stand Lead/Supervisor sessions reaching My Team from their own Team menu get routed properly too.
- **Real, if confusing-looking, data issue clarified:** a report of "I'm only seeing NPO and soccer/DFA stands, not the real Manager view" turned out to be the actual Manager Team Control screen working correctly on top of missing data — with zero schedule rows uploaded for today, the only stands with any data at all are the ones tied to an NPO group, so the screen looked like an "NPO-only" screen. Root cause is the still-missing schedule upload for today's game (flagged separately, needs the ReadyOn import), not a code bug — but the screen now says so plainly with a banner instead of silently looking broken.
- Added status filter chips (All / Fully staffed / Partial / None here) to the Team Control "All stands" list, matching Premium's Check-ins filter chips.

## 2026-09-27-walkin-search-dupe-flag-1
- My Team's inline Add Walk-in search already auto-searches as you type (no need to type the full name) — confirmed matching Premium's search behavior, no change needed there.
- **New:** search results now flag anyone already on today's schedule elsewhere ("⚠️ Already on today's schedule at <stand>") right in the result list, using the same duplicate-detection rule the save step already enforces. With several similarly-named people in a big directory, this is what actually lets a manager tell them apart before tapping Add — "this John Smith is free, that one's already at 214" — instead of only finding out from a rejection message after picking the wrong one.

## 2026-09-27-team-checkin-refresh-1
- **My Team (Concession attendance) brought up to Premium's Check-in quality.** Concession has both regular employees and NPO members in one roster — both are handled correctly throughout:
  - Added a search box + status filter chips (Working / On break / Not arrived / Absent), matching Premium's Check-ins screen — filters instantly against the already-loaded roster, no re-fetch per keystroke.
  - Added a live present/working progress bar at the top, same as Premium.
  - Check In, Mark Absent, Clear Absent, Start Break, and End Break are now instant and optimistic (tap it, see it update immediately, syncs in the background) instead of a confirm() popup followed by a full network reload before anything visibly changes — the same responsiveness Premium's check-in taps already had. Any failure rolls the row back and shows why. Clock Out and Resume were left as-is (reason-required prompt / explicit confirm) since those are more consequential actions.
  - Add Walk-in, when opened from inside My Team, now slides open as an inline panel right there on the roster — search-as-you-type against the employee directory, fill, save, done — instead of navigating to a separate screen and back. Since My Team already knows which stand you're looking at, there's no location picker to fill in at all (one less field than Premium's own walk-in form needs). The standalone walk-in screen still exists unchanged for its other two entry points (Home screen, Team Control overview).

## 2026-09-27-crew-ambiguity-fix-1
- **Real bug fix, found by QA stress-testing a synthetic duplicate schedule (not live data):** Move Worker and Add Walk-in both resolve the destination stand's crew/event_name by matching a "207 Stand"-style pattern. If a stand ever has two differently-named crews at the same physical location and neither name matches that pattern, the code used to silently pick whichever crew name came back first — meaning a moved or walked-in worker could land in the wrong Stand Lead's roster with zero indication anything went wrong. Reproduced concretely against a synthetic dataset (safe test date, cleaned up after — never touched real schedule data). Now: if the crew can't be resolved unambiguously, the worker is not silently misassigned — Move Worker leaves their crew grouping unset (still visible in the Team Control overview by location) and Add Walk-in gives them their own walk-in crew group (same fallback already used when a stand has no crew at all) — and the acting manager gets an explicit warning toast either way instead of nothing.

## 2026-09-27-notify-audit-1
- **Real bug fix, notification gap:** when a warehouse employee marks a delivery "Delivered," the "ready to verify" push only ever went to Warehouse Supervisor accounts — if no supervisor is actually working that game (smaller events sometimes run with just a manager + employees), nobody got notified at all. Now falls back to the Warehouse Manager when no supervisor is active.

## 2026-09-27-stock-fallback-notify-1
- **Real bug fix, notification gap:** when a Stock request comes in for a stand with no warehouse coverage assignment set for the day, the fallback push only went to Warehouse Employee accounts — the Warehouse Manager and Warehouse Supervisor got nothing until they happened to open the app. Found while auditing notification routing ahead of tonight's game. Fallback now pushes to all three warehouse roles, matching how Food requests already always alert the Food Manager.

## 2026-09-27-transfers-date-filter-1
- **Real bug fix:** the manager's name showed twice on the Warehouse screen — once in the header, once again right below in the role card, word for word. The header now just shows "Auto-refresh 10s"; the role card already has the name.
- **Real bug fix, the big one:** a transfer the warehouse manager had already approved (wh_confirmed_at set) could still sit in "All Transfers" and every open-count, because its literal `status` column only reaches `verified` until a completely different person — the receiving concession stand's own regular Manager — does their own separate final receipt confirm. So the same row would show "✓ Confirmed" on its own line while still counting as "Open" above it. Every warehouse-side list/count now treats wh_confirmed_at as done, regardless of what the stand's own confirm step still says.
- Replaced the "Today's venue / Last 2 days / All open" three-button filter on Transfers with an actual date picker + one "All open" toggle — pick the exact day directly instead of guessing which preset bucket it falls into.
- Removed the "Download CSV" button from the Transfers pane — it duplicated the Stand Transfer Report (same underlying data, but grouped by stand and including waste), which is now the one place to export transfers.

## 2026-09-27-supervisor-tiles-1
- Warehouse Supervisor now gets the same tile menu as the Manager instead of the old text tab-bar — two big tiles, 🚚 Transfers (red, since verifying deliveries is their main job) and 📥 Requests, each showing a live open-count the same tab-bar badges always tracked. Employee's single-list screen was left as is — one list plus one full-width Quick Drop button is already the simplest shape for a screen with exactly one job; a tile menu would only add a navigation step for no benefit there.

## 2026-09-27-employee-supervisor-declutter-1
Reviewed Warehouse Employee and Warehouse Supervisor's own screens the same way the manager's screen was — Supervisor's tab-bar (Transfers + Requests) was already fine, two real destinations. Two real things found for Employee/Force Restock:
- Warehouse Employee's tab-bar only ever showed one visible tab — "Available Jobs" — since every other tab is manager/supervisor-only. A tab strip with a single option is pure decoration, so it's hidden for Employee too now, same as the manager cleanup; the list just shows directly.
- Force Restock / Quick Drop / self-service delivery showed two ways to add the same item at once: the big-button item picker/menu, and a plain "Add extra item" text box, both wide open on screen doing the same job. The text box is now tucked under a collapsed "➕ Add extra item" you tap open only if what you need genuinely isn't on the picker's list — still there as the escape hatch, just not competing with the main way to add something. Stays open by default on a plain assigned delivery, where there's no picker and it's the only way to add something extra.

## 2026-09-27-self-transfer-one-tap-1
- A true self-transfer (Warehouse Manager assigned it to himself and is the one physically delivering it) used to still require three separate taps — Mark Delivered, then Verify & e-sign (typing his own name), then Approve — for something one person did entirely themselves. "Mark Delivered" now detects this case and does all three in one tap: the same inventory ledger write verification would have made, the verify stamp, and the approval stamp, landing on `verified` (or straight to `confirmed` for a warehouse↔warehouse hub transfer, per the hub fix above) instead of sitting at `delivered` waiting on steps nobody else needs to do. A stand delivery someone else picks up, or one a supervisor/different person verifies, is completely unaffected — the full sign-off chain still applies whenever a different person is actually meant to check the work.

## 2026-09-27-hub-transfer-confirm-fix-1
Found by tracing the full self-assign lifecycle end to end as each warehouse role (network policy blocks this sandbox from reaching the live site/Supabase directly, so this was a careful code trace rather than clicking through the deployed app).
- **Real bug, biggest one found:** the Warehouse Manager's own approval (`whFinalApprove`/`whConfirmTask`) only ever set `wh_confirmed_at` — the transfer's actual `status` only ever became the literal `'confirmed'` through `mtConfirmTransfer()`, a screen that belongs to a concession stand's own regular Manager. A warehouse↔warehouse hub transfer (MAS/DFA) has no stand and no such manager attached to it at all, so it could never reach real `'confirmed'` status — it would sit in every "Open" count forever, permanently accumulating over a season. Fixed: for a hub transfer specifically, the Warehouse Manager's own approval now sets `status:'confirmed'` directly, since there's no separate stand-side receipt to wait for. Stand deliveries are unaffected — they still wait on the stand's own Manager for the final confirm, which is a real, separate check.
- **Real bug:** opening a specific transfer by id (tapping it from a list) skipped resetting the item-picker panel — a stale picker left open from an earlier QR/self/force-restock session in the same browser tab could still be showing on top of an unrelated, manager-assigned transfer for a different stand. Now resets unconditionally on every open.

## 2026-09-27-picklist-delivery-record-1
- Removed Stock Report (warehouse counts) entirely — confirmed nobody counts stock mid-game, so it was dead weight. The "Stock Report" tile/pane is now dedicated solely to Stand Transfer Report, which is what was actually useful in that pane.
- The 🖨️ print button on a transfer is no longer limited to before pickup — it's available at every stage. Before pickup it prints a Picklist (empty box to tick off while pulling, same as the Yellow Dog picklist this replaces). Once delivered/verified/confirmed, the same button prints a Delivery Record instead, showing the actual delivered quantities with a checkmark — the document meant to be entered into Yellow Dog's Purchasing/Worksheet Transfers.
- Restyled both to match the app's own Inventory Stand Sheet print (bordered header box, plain table) instead of a separate custom design, so every printed document in the app looks like one consistent system.

## 2026-09-27-warehouse-mgr-polish-1
- **Real bug fix:** every back button on the manager's tile screens read "← Back Back" — the page-header component already appends "Back" via CSS after the arrow, and the new back bar was also putting the word "Back" in as literal text, doubling it. Now just the arrow, matching every other back button in the app.
- **Real bug fix:** the "Today at a glance" stat boxes on Approvals (Open/Unassigned/Awaiting supervisor/Needs your approval/Partial-short) were styled exactly like other tappable stat tiles elsewhere in the app but did nothing when tapped. They're now real: "Needs your approval"/"Partial or short" scroll down to the list right below (they're already in it); "Open"/"Unassigned"/"Awaiting supervisor" jump to All Transfers, since those transfers aren't listed on this screen at all.
- **Real bug fix:** switching into the Requests pane was the one mode that didn't refresh anything — every other pane (Transfers, Stock Report, etc.) re-fetched the moment you opened it, but Requests just showed whatever the background 10-second cycle had last rendered, which could be stale or from before the pane was even opened. Reported as "still old version, old details." Now refreshes immediately like every other pane.
- **Real bug fix:** picking "MAS → DFA" (or any Warehouse↔Warehouse transfer) and then switching to Self Transfer without finishing left the previous stand/items sitting in the form underneath — and separately, Self Transfer's own "assigned to you" pick was getting silently overwritten back to the stand's auto-routed owner the moment its items loaded. Both fixed: every entry into Create Transfer now starts from a clean form, and a self/hub transfer's assignee is no longer auto-overwritten once you've explicitly chosen yourself.
- Confirmed working as intended, no changes needed: the Assign & Team coverage tool (area + specific-stand assignment, one save).

## 2026-09-27-print-picklist-1
- New: **Print Picklist** — a 🖨️ button on each not-yet-picked-up transfer in the Warehouse Manager's/Supervisor's Transfers list, modeled on the Yellow Dog Inventory paper picklist this replaces day-to-day (stand, item/pack, a big QTY box, and a checkbox column to tick off while physically pulling stock) — for handing to someone pulling stock without a phone, or keeping a paper backup.
- Stand Transfer Report now takes an optional stand filter (leave blank for every stand) alongside the date, matching how Yellow Dog's own Transfers screen is filtered before a post-game download.

## 2026-09-27-standtransfer-report-eta-fix-1
- Verified against the described workflow and confirmed already correct, no changes needed: manager pre-game transfer assignment + self-transfer, warehouse-manager self-verify/self-confirm on any transfer (not just self-delivered — a manager can already open any employee's delivered transfer from the Transfers list and sign off himself, so a busy warehouse supervisor is never a blocker), Force Restock's single QR scan covering multiple item adds with no re-scan, and stock-request delivery offering both a QR scan and a no-scan "Finish delivery" choice.
- **New: Stand Transfer Report** (Warehouse Manager → Stock Report pane) — one report split by stand for a chosen date, each stand showing everything transferred to it plus any waste that stand's supervisor/lead logged that same day, previously only visible on two separate, unconnected screens. Available as one CSV (grouped by stand) or a PDF with one printed page per stand.
- **Real bug fix — ETA misuse:** picking URGENT on a stock request was auto-setting a 10-minute delivery deadline — not achievable for an actual warehouse delivery, and the direct cause of nearly every urgent request going "overdue" within minutes of being sent. Removed the 10m chip entirely and raised URGENT's default to 15m.
- **Real bug fix — overdue notification spam:** every overdue stock request pushed an alert to *every* manager, admin, and warehouse manager stadium-wide, regardless of whether they had anything to do with that stand — combined with the ETA bug above, this meant managers were getting flooded. Overdue alerts now route through the same unified coverage data Assign & Team writes to, reaching only the people actually covering that stand, falling back to warehouse managers only (not a stadium-wide blast) when nobody has been assigned there yet.

## 2026-09-27-warehouse-coverage-unify-1
- Removed the redundant guidance notices repeated inside the Available Jobs and Transfers panes (Warehouse Employee/Supervisor) — the same "tap a stand, deliver, done" message was already shown right above the tab-bar in the dismissible first-game tip, so it was appearing twice on screen and eating space. Kept the one dismissible copy.
- **Real architecture bug, fixed:** warehouse assignment was split across two disconnected systems — the "Assign & Team" screen wrote area/group assignments into `game_day_assignments`, while a completely separate, now-orphaned "Zone Assignments" tool was the only thing that ever wrote a specific-stand assignment, into a different table (`zone_assignments`) — and that tool's HTML form had already been removed, leaving stand-based assignment with no working UI at all. This is exactly the "sometimes by group, sometimes by stands" behavior reported.
  - "Assign & Team" now has ONE form for both: pick an area (a group of stands) and/or specific stand(s) from today's game directly, saved together on the same row.
  - Added a "Remove this person's coverage" button (previously only reachable through the dead tool).
  - The "My Stands" filter and new-stock-request push notifications now both resolve through this same unified coverage data (area or direct stand, today's game specifically — the old table had no date, so a stale assignment from a past game could silently carry forward forever), falling back to the legacy table only if nothing was ever set there, and to "notify everyone" only if the stand truly has no one assigned — same safe default as before.
  - Deleted the dead "Zone Assignments" JS (zaLoadPeople/zaSaveAssignment/etc.) — fully unreachable code left over from when its form was removed.

## 2026-09-24-warehouse-mgr-fixes-2
- **Real bug fix:** the manager's tile grid was rendering as a vertical stack instead of the intended 2-column grid — an inline `display:block` set in JS was overriding the `.action-tiles` class's `display:grid`. Removed the override.
- Golf Cart hidden from all access for now — removed from the Warehouse Manager tile grid, the login screen's "Golf Cart Key" button, the Manager's Records tab and quick-tools grid, and the Admin "Golf cart drivers" card (hidden, not deleted, to avoid breaking `adminLoadDrivers()` which still targets those element ids on every Admin tab open). All underlying screens/functions are left intact — this is reversible by restoring the removed buttons/entries.
- The manager's "← Back to menu" button looked different from the arrow back-button used everywhere else in the app (Create Transfer, Approvals, etc.), which read as inconsistent/confusing. It now reuses the exact same `page-header`/`back-btn` component, with the pane's name shown next to it (e.g. "📊 Stock Report").
- **Real bug fix — transfer sign-off:** a transfer the Warehouse Manager delivered himself could only be verified by a Warehouse Supervisor — the manager, despite outranking supervisor, saw "waiting for a warehouse supervisor" on his own delivery with no way to move it forward himself. Verification is now open to warehouse_manager too (in addition to warehouse_supervisor), so a manager can verify and then give final approval on his own deliveries without needing a supervisor to sign first.
- The "🔔 Game-Day Alerts ON" banner and the "First game" tip were both showing at full size on every visit to the Warehouse screen (employee and manager alike), eating a large chunk of a phone screen for information that's either already shown elsewhere (the header's own 🔔 bell already reflects alert status) or only useful once. The alerts-on banner is gone now that permission is granted (the header bell already covers it); the first-game tip gets a dismiss (✕) that's remembered per person so it doesn't come back.
- **Real bug fix — stock requests:** opening the Request Stock screen for a stand showed a "✅ This request already went through — it's in the queue" banner sourced from *any* open request at that stand from *anyone*, worded as if it were the current person's own submission — reported as showing up at 142 Inferno for an item the person had never requested. Removed that proactive banner; the actual duplicate check (a confirm prompt when someone's own submission genuinely overlaps an existing open request) is untouched and still runs at submit time.

## 2026-09-24-warehouse-mgr-tiles-only-1
- Fixed the tile restructure being incomplete: the manager was seeing the old tab-bar slider (Transfers/Requests/Stock Report/Golf Cart) *and* the new tile grid at the same time, stacked on top of each other. The tab-bar is now hidden entirely for Warehouse Manager — tiles only. Employee/Supervisor are unaffected; they still get the original tab-bar exactly as before.
- Expanded the manager's tile grid from 4 to 7: **Create Transfer**, **All Transfers**, **Approvals**, **Requests**, **Stock Report**, **Golf Cart**, **Assign & Team** — nothing that used to live under the old tabs was dropped.
- All Transfers / Requests / Stock Report / Golf Cart now open the exact same underlying panes Employee/Supervisor use (no duplicated markup or data-loading logic), just with a "← Back to menu" button above them — the thing that was completely missing before ("i dont have that back option at all"). Phone/hardware back does the same thing while one of these is open.
- Create Transfer: replaced the two separate "MAS → DFA" / "DFA → MAS" buttons with a single "Warehouse ↔ Warehouse" tile that reveals one dropdown (From → To) and one "Start transfer" button.
- Create Transfer: removed the separate "Upload CSV" tile — it just scrolled to the CSV card already sitting on the same screen, which read as the same thing twice. The CSV card itself is unchanged and still reachable by scrolling.
- Approvals: removed the "Download all transfers (CSV)" button — it was a duplicate of the Download CSV button that already lives in the Transfers pane, and had no distinct purpose.
- Stock Report: added a "🖨️ Download as PDF" button next to the existing CSV export, using the same print-to-PDF pattern (browser Print dialog → Save as PDF) as Premium's check-ins export — no new library needed.

## 2026-09-24-warehouse-stock-report-1
- Renamed "Inventory" to "📊 Stock Report" (tab, tile, and its own notice text) — the naming right next to "Transfers" made it sound like a second task you create/assign, when it's actually just a read-only summary of what completed Transfers already delivered. No self/assign concept needed there because there's nothing to do — it's derived automatically.

## 2026-09-24-warehouse-mgr-restructure-1
- Properly restructured the Warehouse Manager's tools, instead of the previous quick patch — everything used to be crammed onto one page (stat cards, quick-action buttons, a coverage form, and a collapsed drawer holding Create Transfer + Upload CSV + a deprecated Stand Assignments form all stacked together). That's gone.
- New pattern: the same tile-then-dedicated-screen structure the worker home screen already uses for Checks/Requests/Team (a square icon tile that opens one focused screen, not everything visible at once). Four tiles: **🚚 Create Transfer** (Self Transfer, DFA↔MAS, manual build, and CSV upload all live inside this one screen, reached via their own mini tiles), **✅ Approvals** (a live badge shows how many need him before he even taps in; the screen itself only lists what's actually actionable — verified deliveries and partial/short ones — not the full open-transfers list), **📦 Inventory** (shortcut into the existing tab, no duplicate screen needed), **👥 Assign & Team** (the warehouse coverage tool, on its own).
- Dropped the deprecated "Stand assignments" (`za-*`) form entirely — it had already been superseded by the coverage tool and was hidden via `display:none`, just taking up dead space in the old drawer.
- Fixed a real bug found while moving this: `wh-coverage-card` used to be recreated fresh on every render; making it static HTML meant the old cleanup code would have deleted it permanently on the very next render if left in place — caught and fixed before shipping.

## 2026-09-24-warehouse-mgr-overhaul-1
- Removed "Assign people to locations" from Premium — the Check-ins roster already covers who's where; the old "who's assigned where" card only still shows for a Premium Employee session checking their own spot.
- Warehouse Manager: added himself as a selectable "🙋 Myself" option in every transfer's Assign-to dropdown — he could never actually assign a transfer to himself before, only to a warehouse_employee.
- Fixed a real bug in the manager's stats: "awaiting your approval" was checking the wrong transfer status (`delivered` instead of `verified`) and never matched what the Transfers tab actually let him approve. Rebuilt as clear stat chips: Open / Unassigned / Awaiting supervisor / Needs your approval / Partial-short.
- Added partial/short-delivery detection — a transfer where any item came in under the requested quantity now shows a "⚠️ Partial" flag right in the list, instead of only being discoverable by opening it and checking every item.
- Added a 2-column "Needs Your Attention" action grid (same layout as the Manager home's Supervisor tools): Self Transfer (any stand, pre-assigned to himself), Needs Approval (jumps to Transfers, switched to All so nothing's hidden by the venue filter), DFA↔MAS quick transfer (now also pre-assigns to himself, since that's the common case), and Download CSV.

## 2026-09-24-premium-polish-2
- Removed "Stock filled at a location" — not needed for Premium, cut entirely (UI, backend, and the `premium_stock` table).
- Added a pulse animation on a row and a bounce on the status button when you mark someone present/absent, plus real press feedback on every check-in button (Present/Absent/Move) — the screen felt flat before, this makes every tap register visually, not just after a network round trip.
- Added ⬇️ CSV and 🖨️ PDF export for today's check-ins, grouped by location with a present/total header — the PDF is the same "styled page → browser Print → Save as PDF" trick already used elsewhere in this app (Stand Sheet, timesheets), not a new dependency.
- Walk-in search now also checks a new `premium_positions` table (seeded from today's real roster — Catering Services Supervisor, Expo Captain, Suite Attendant, Bartender, etc.) before falling back to the generic employee directory, so Role auto-fills correctly for anyone already in today's game instead of needing to be typed by hand.

## 2026-09-24-premium-walkin-redesign-1
- Rebuilt Add Walk-in for Premium, taking inspiration from the Supervisor/Manager "Add Walk-in Worker" flow: same live search-as-you-type against the employee directory (tap a result to fill name + real ID instantly), the same 8-digit employee ID field with a 5-digit fallback, and a big colorful trigger tile instead of a plain "Add walk-in" text button.
- The panel itself got a real design pass — gradient header, icon badge, and a smooth open/close transition instead of a flat gray box that just appeared.
- Backend now upserts on (date, employee ID) instead of a bare insert, so picking someone from the directory who's already on today's roster elsewhere updates their row instead of erroring out.

## 2026-09-24-premium-checkins-redesign-1
- Rebuilt the Premium Check-ins card for real gameday use on a phone with 80+ people to manage: a progress bar + live present/total count, a search box to jump straight to a name instead of scrolling, and filter chips (All / Not checked in / Present / Absent) to see who's still missing across every location at once.
- Rows are now compact and color-coded by status (green/red left border + tint) instead of a text label — readable at a glance. Present/Absent are big square icon buttons (✓/✕) sized for a thumb; Move collapsed behind a small toggle instead of a full-width dropdown on every single row, so the list doesn't run twice as long as it needs to.
- Location headers are sticky while scrolling and collapsed by default (tap to open your location) — auto-expand when searching/filtering so results are never hidden inside a closed group.
- Present/Absent/Move now update the screen instantly (optimistic UI) instead of waiting on a round trip before showing the change, with an automatic revert + error toast if the save actually fails.

## 2026-09-24-warehouse-big-buttons-1
- Added big, one-tap shortcuts for warehouse-to-warehouse transfers ("DFA Warehouse → MAS Warehouse" / "MAS Warehouse → DFA Warehouse") using the same large tappable-row style as the Supervisor's "All Stands Live" menu — no more digging through a collapsed drawer's plain stand dropdown to find them. Tapping one opens the tools drawer, pre-selects the destination, and loads its items.
- Fixed a real bug: the default "Today's venue" filter on the Transfers tab could silently hide a warehouse-to-warehouse transfer if today's scheduled game was at the OTHER venue — it only ever checked one venue. Warehouse hub transfers now always show under that filter regardless.
- Added a big "Download all transfers" shortcut next to the two transfer buttons (same CSV export already on the Transfers tab, available to every warehouse role, not manager-only).

## (data-only) Premium roster completed, all 4 managers on shared login
- `sql/25_premium_roster_complete_today.sql`: added the 4 roster rows that were missing from today's schedule (Pouessel, Larson, Brooks, Renguso — the last 3 had no Area in the source CSV, bucketed under a new "Premium — Floating" location). Normalized Larson's and Pouessel's manager logins onto the shared `70000` + last name scheme, so all 4 Premium Managers (Hernandez, Crnjac, Larson, Pouessel) work identically. No app code changed — data/SQL only, no new BUILD_TAG.

## 2026-09-24-premium-common-login-1
- Added a Premium shared-ID login (`70000` + last name), same convenience as Warehouse's shared `60000` ID — no per-person ID to memorize.
- Granted Premium Manager access to Hernandez, Nestor (`170000` / PIN `7001`) and Crnjac, Natasha (`270000` / PIN `7002`), both usable via the shared 70000 ID.
- Added a date picker to the Check-ins card — it was hardcoded to today with no way to look back. Now defaults to today but can view any date, including the new yesterday demo seed.
- Seeded yesterday's Premium roster (`sql/23_premium_schedule_yesterday.sql`) — same people/locations as today's seed, shift times normalized to a clean 12:00 PM–10:00 PM block.

## 2026-09-24-warehouse-transfer-hubs-2
- Fixed a real defect in the warehouse item catalog seed: it used the concession sheet's Chargeable/Non-Chargeable/Supplies categories, but Create Transfer's item list only groups by ALCOHOL/BEVERAGE/FOOD/SUPPLIES — every item would have silently landed in a catch-all "OTHER" bucket instead of grouping properly. Recategorized correctly, and added "CUP SOUVENIR SODA 32OZ CHURCHIL" (32oz souvenir cup) to the catalog.
- Polished Create Transfer's item picker: each item is now its own card with a shadow, a highlighted border once you've set a quantity, and a deeper +/− stepper, instead of flat divider-separated rows.

## 2026-09-24-warehouse-transfer-hubs-1
- Added "DFA Warehouse" and "MAS Warehouse" as Warehouse transfer endpoints — both now selectable in Create Transfer regardless of the concession-only stand filter, so Warehouse can move common bulk items (water, beer, chips, buns, gloves, CO2, etc. — 22 exact items, matched to names already used elsewhere in the app) between the two venue warehouses.
- Added a "⬇️ Download CSV" button on the Transfers tab — exports every open transfer with its items (stand, status, item, qty requested/delivered) so a transfer can be handed off or kept as a record outside the app.
- Run `sql/22_warehouse_transfer_hubs.sql` in Supabase to create the two stand rows and seed their shared item catalog.

## 2026-09-23-premium-checkins-1
- Added Premium's own day-of-game roster/check-ins: "✅ Today's check-ins" on the Premium Manager screen — Present/Absent per person, move someone between Premium locations, and add a walk-in. Own table (`premium_schedule`), never touches concession's `schedule`.
- Seeded 2 demo Premium Manager logins and today's roster (~75 people matched from the 09/05 game CSV against the 13 Premium locations) — `sql/20_premium_schedule.sql` (schema) then `sql/21_premium_demo_seed.sql` (data).
- Added visual depth across the whole app: buttons now have a subtle colored shadow and lift on hover/press instead of sitting flat, and cards got a slightly deeper shadow — same CSS, so Premium and every existing screen (Manager, Warehouse, etc.) all picked it up together.

## 2026-09-22-premium-department-2
- Redesigned the Premium Manager screen: the roster is now what you see first, and Locations / Assign People / Stock all collapse into one "🧰 Premium Tools" drawer (same pattern as Warehouse Manager's tools drawer) so setup work doesn't crowd the overview.
- Assigning people to locations now has a search box, a live "N selected" count, and a Clear button — the checklist was getting hard to track while assigning against a long location list.
- Added "Stock filled at a location" — item + quantity + notes + filled-by, one row per location representing what's there right now (not a running ledger). Own `premium_stock` table, never touches concession's `inventory_entries`. Includes a clean landscape print-out per location for handing out or posting.

## 2026-09-22-premium-department-1
- Added a new Premium department, isolated the same way Warehouse/NPO are: its own `premium_locations` + `premium_assignments` tables, own `premium_employee`/`premium_manager` login roles, and its own screen. A Premium Manager creates location names and assigns people to them; a Premium Employee sees only their own assigned location(s). Neither can see concession/warehouse/NPO/food data. Requires running `sql/18_premium_department.sql` in Supabase.

## 2026-09-20-food-runner-area-notify-1
- Food Runners now get an immediate, separate push notification for a new request in their own assigned area (Food Manager → Runner Areas), instead of waiting for a Food Manager to notice the queue and manually assign it. Doesn't change the manager's own manual assignment step — this is an extra heads-up, not an auto-claim.

## 2026-09-20-it-duplicate-ticket-fix-1
- Fixed the "you already reported this" duplicate-ticket warning on Report IT Issue — it referenced a database column that doesn't exist (`requested_by` instead of the real `reported_by`), so every check has silently failed since it was built and the warning never actually showed. This is the real cause behind repeated POS tickets flooding in with no warning.
- The check now also catches a ticket that's been claimed but not yet resolved, not just an untouched one — previously the warning disappeared the moment a tech tapped "On the way," even if the problem wasn't actually fixed yet.

## 2026-09-20-gameday-request-flow-improvements-1
- Request Stock: added tap +/- buttons next to each item's quantity, matching Force Restock's stepper — no more opening a number keyboard to request 1 or 2 cases of something.
- Warehouse "To Deliver": an urgent stock request now shows an unmistakable red "URGENT" badge with a tinted card background, instead of only a thin colored line on the edge.

## 2026-09-20-mobile-a11y-improvements-1
- Restored pinch-to-zoom (was disabled app-wide — a real accessibility problem for anyone needing to zoom in).
- Enlarged touch targets on the checklist Done/Issue/N/A buttons.
- Every tappable card in the app (not just real buttons) now works with a keyboard and is announced properly to screen readers — added automatically, app-wide.
- The inventory-reconciliation and break-time-sheet reports now show as stacked, labeled cards on a phone instead of a shrunk, unreadable multi-column table; unchanged on tablet/desktop.

## 2026-09-20-branded-dialogs-1
- Replaced the browser's native gray confirm popup with one that matches the app for the highest-stakes actions: log out, leave stand, start a new game (wipes attendance/stock/IT data), replace the entire inventory sheet, delete all check-ins.

## 2026-09-20-duplicate-submit-protection-1
- "Other" stock requests and adding a walk-in worker are now protected against accidental double-tap submissions, the same way every other submit button in the app already is.
- Removed the old "Request Worker Move" approval flow and the Supervisor "Moves" tab — dead since the working My Team → Move Stand flow replaced it; the tab could never show anything and its Approve/Deny buttons were unreachable.

## 2026-09-20-security-hardening-1
- Closed 9 places (including creating/editing staff logins, replacing the whole inventory sheet, and the warehouse delivery sign-off chain) where a menu hid the button from the wrong role, but the action itself had no check of its own and stayed reachable directly. Most severe: a non-Admin manager-tier session could previously grant itself or anyone else Admin/Warehouse-Manager access.
- Fixed 14 places where one person's typed text (a request note, a warehouse message, a worker's name) was shown to a *different* role's screen unescaped — could break the layout, or worse, run injected content in that other person's browser.

## 2026-09-11-feedback-pdf-export-1
- Worker Feedback now exports as a clean, branded PDF (alongside the existing CSV) — 👍/👎 totals, one row per feedback entry.

## 2026-09-11-support-mgr-team-back-fix-1
- Fixed Support Manager "My Team": tapping a stand then pressing Back now returns to the Team Control stand list instead of landing on the wrong screen.

## 2026-09-11-force-restock-qty-and-remove-1
- Force Restock: add a typed quantity in one action (stepper + Add button) instead of tapping +1 repeatedly — e.g. 30 cases is one action, not 30 taps.
- Force Restock: added items now have a Remove button. Removing a force-logged item posts a compensating stock movement so the stand's counted stock isn't left inflated.

## 2026-09-11-leadership-ui-cleanup-batch1-1
- Removed the redundant "All-Stadium Request Monitor" tile (duplicated "See Existing Requests").
- Removed duplicate Team Control + Add Walk-in tiles for Support Manager / Manager (the main My Team tile already covers both).
- Support Manager: hid the Game-Day Feedback button (not their role).
- Manager: "Coverage Today" bar now shows only on the Home tab, not on every tab.

## 2026-09-11-team-control-phone-card-redesign-1
- Redesigned Team Control stand cards for phone use: color-coded left edge, big headcount, plain-word status chips ("Fully staffed" / "Partial" / "None here", "☕ 2 on break", "❌ 1 absent").

## 2026-09-11-warehouse-transfer-venue-filter-1
- Warehouse Transfers screen: added a Today's venue / Last 2 days / All open toggle so old open transfers from other events don't clutter tonight's queue.

## 2026-09-11-explicit-sort-order-column-1
- Added a `sort_order` column to `stand_sheets` so inventory display order matches each stand's real paper form, independent of database insertion order.
- Corrected Sun Devil Soccer Stadium's item order and repaired items lost during reordering.

## 2026-09-11-view-continue-partial-inventory-1
- A phase that shows "already completed" now shows how many items are recorded and, if partial, a way back in to fill the rest — resubmitting updates the same entry instead of colliding with duplicate-protection.

## 2026-09-11-admin-roll-countout-button-1
- Admin dashboard: "Roll Count Out → next Exp Start" button for multi-day events. Deliberate, admin-pressed — the safe version of the removed auto carry-forward.

## 2026-09-11-remove-carryforward-onhand-1
- Removed the automatic Count Out → On-Hand carry-forward that was making a stand's own closing count appear as that same night's opening. Reset affected values.

## 2026-09-10-dfa-standard-names-1
- Desert Financial Arena stands standardized to "DFA 111 / 143 / 191".
- Schedule upload now maps ReadyOn's per-sport DFA event names to the sport-neutral stand name automatically.
- Fixed a date-strip bug that only handled September dates.

## Earlier
Earlier work (game-day fixes, NPO restore, request category filters,
PWA update-reload, duplicate-request-flood fix, walk-in search, DFA
stand creation, and more) predates this changelog. See git history once
the repo is initialized.
