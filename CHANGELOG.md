# Changelog

Builds are tagged in `index.html` as `BUILD_TAG` and shown on the login
screen footer. Newest first. Dates are the build date, not necessarily
the deploy date — always verify the tag on the live site after deploying.

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
