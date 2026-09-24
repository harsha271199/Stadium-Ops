# Changelog

Builds are tagged in `index.html` as `BUILD_TAG` and shown on the login
screen footer. Newest first. Dates are the build date, not necessarily
the deploy date — always verify the tag on the live site after deploying.

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
