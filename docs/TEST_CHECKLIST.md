# Stadium Ops Platform — Test Checklist (2026-08-24 session)

Covers everything built or changed today. Test in this order — later
sections assume earlier ones already work. For each row: check the box if
it worked as expected, and write a one-line note if it didn't (screenshot
helps too). Anything you mark broken, send back to me with the note and
I'll fix it before the next round.

**Before you start:** confirm the login screen footer shows build tag
`2026-08-24-unified-stand-picker-stock-it-1` (or later). If it shows an
older tag, the latest version hasn't deployed yet — stop and check
Netlify first, testing against a stale build will produce false bugs.

---

## 0. Login credentials you'll need

| Who | ID field | Last Name field |
|---|---|---|
| Any of the 8 managers | `97531` (shared code) | Their real last name |
| Worker / Stand Lead / Supervisor | Last 5 digits of real ID | Real last name |
| Warehouse (Employee/Supervisor/Manager) | Tap "📦 Warehouse" → own ID + PIN | — |
| Golf cart (anonymous) | Tap "🔑 Golf Cart Key" → ID + last name | — |

**Manager tiers to test** (confirm each lands with the RIGHT access — this is the main thing to check today):
- `97531` + **Kagithoju** → should be **Admin** (sees everything, including ⚙️ Admin section)
- `97531` + one of: Gaona De Cazares / Byrd / St. John / Burke / Andriyansa / Crnjac / Hernandez → should be **Support Manager** (Overview only, no Roster tab, no Inventory/Records/Admin sections at all)

---

## 1. Manager login & access tiers

- [ ] Log in as **Kagithoju** (`97531` + `Kagithoju`) → lands on manager home
- [ ] Sidebar shows **Overview, Inventory, Records, Admin** — all 4 visible
- [ ] Overview → Roster tab shows staffing stats + worker list (no Feedback/Checklists buttons here anymore)
- [ ] Records → new **"📝 Reports"** tab exists, contains Worker Feedback + Stand Checklists (moved from Roster)
- [ ] Admin section is visible and opens correctly

- [ ] Log in as **Byrd** (or any of the other 6) → lands on manager home
- [ ] Sidebar shows **ONLY Overview** — Inventory, Records, Admin buttons are gone entirely (not just hidden-but-clickable)
- [ ] Overview subtabs are **only Stock, IT, Live** — no Roster tab at all
- [ ] Try navigating directly to Inventory/Records/Admin some other way — confirm there's truly no path in

- [ ] Wrong last name with the right code (`97531` + a name not on the list) → clear error, not a crash
- [ ] Right last name with wrong code → falls through to normal worker login attempt (expected — not a manager)

## 2. Manager — Live tab (now has real clock-out)

- [ ] As any manager tier, Overview → Live shows every stand's active workers
- [ ] Tap "Clock out" on a worker → prompted for a reason
- [ ] Leaving the reason blank → blocked with an error, doesn't submit
- [ ] Submitting with a reason → worker disappears from the live list, confirm toast shows
- [ ] Someone flagged 2+ hours past scheduled end shows the ⏰ orange flag; 5+ hours shows the ⚠️ red "likely forgot to clock out" flag with pre-filled reason suggestion

## 3. Manager — Stock tab (request for another stand)

- [ ] Overview → Stock shows the **"📝 Request stock for another stand"** button (support managers should see this too)
- [ ] Tap it → opens the request screen, submit for some other stand
- [ ] Confirm it actually lands in that stand's incoming requests (check via Warehouse or that stand's "My Stock Requests")
- [ ] After submitting, returns to the manager home screen (not the worker home screen)

## 4. Supervisor — unified Request Stock / Report IT (no more separate button)

- [ ] Log in as a Supervisor
- [ ] Home screen: confirm **"Stock request for another stand"** button is GONE (this is expected — replaced, not missing)
- [ ] Go to Requests → **Request Stock** → a **"Which stand?"** dropdown appears at the top, pre-selected to your own stand
- [ ] Leave it on your own stand, submit → works exactly like before (real item list, per-item case quantities)
- [ ] Change the dropdown to a different stand → item list reloads with THAT stand's real items (not the old generic list)
- [ ] Submit for another stand → confirm it's labeled "(Supervisor — for [stand])" on the receiving end
- [ ] Requests → **Report IT Issue** → same dropdown appears, same behavior (own stand default, can switch, submits correctly either way)
- [ ] Log in as a plain **Worker or Stand Lead** → confirm NEITHER screen shows the stand dropdown at all (should be invisible, locked to their own stand like always)

## 5. Zone assignments (Warehouse Manager sets who covers what)

- [ ] Log in as Warehouse Manager → Transfers tab → find the **"🗺️ Stand assignments"** card
- [ ] Assign a warehouse employee to 2–3 stands, save
- [ ] Log in as that warehouse employee → Requests tab → confirm a **"📍 My Stands / 🗺️ All Stands"** toggle appears, defaults to My Stands, shows only their assigned stands
- [ ] Tap "All Stands" → confirms it un-narrows to everything
- [ ] Log in as a DIFFERENT, unassigned warehouse employee → confirm they see everything, no toggle at all (nothing changed for them)
- [ ] Repeat the assign step for a Supervisor → log in as that supervisor → Checklists & Inventory Status and Stand Transfer Record both show the same toggle, same narrowing behavior

## 6. Portable stand lead-access (Warehouse Manager toggle)

- [ ] Warehouse Manager → Transfers tab → **"🎚️ Portable stand access"** card, confirm it lists real stands from today
- [ ] Toggle ON for one small/portable stand
- [ ] Log in as a Bartender or Student scheduled at THAT stand → confirm they now see Checks, Requests, Food Safety, My Team tiles (Stand-Lead-level access) instead of the plain worker screen
- [ ] Log in as someone at a stand that's still OFF → confirm they're still a plain worker, unaffected

## 7. Golf cart — return flow redesign

- [ ] Check out a cart key (run through pre-use inspection as normal — confirm this part is unchanged)
- [ ] Tap "Return my key" → confirm you're asked "Any issues with the cart?" (not an immediate return)
- [ ] Choose **"No issues"** → key should show as ✅ Available immediately for the next driver, no waiting
- [ ] Choose **"Report an issue"** → must enter a description (blocked if empty) → submit → cart shows **"🚫 Out of service"** on the key board, NOT selectable by the next driver
- [ ] As Manager or Warehouse Manager, confirm a push notification arrived for both cases (routine return = FYI only; issue = "needs review")
- [ ] Manager's Carts tab AND Warehouse Manager's Cart tab both show **"⚠️ Carts out of service — needs review"** — but ONLY for the flagged one, not the routine return
- [ ] Tap "Mark repaired & back in service" from either screen → cart becomes available again

## 8. Golf cart driver admin (restored)

- [ ] Warehouse Manager → Cart tab → confirm **"➕ Approve a driver"** form is there with working ID + Name fields
- [ ] Add a driver → confirm they appear in the list below, and can now log into Golf Cart Key with that ID
- [ ] Revoke a driver → confirm they can no longer check out a key

## 9. Sanitizer log — initials removed

- [ ] Food Safety → Sanitizer log → confirm all 3 readings (Set Up / Mid-day / Close) no longer have an "Initials" field
- [ ] Submit a sanitizer log → confirm it still saves fine without initials

## 10. Install prompt

- [ ] Open the app fresh on an Android phone (not yet installed) → confirm a bottom banner appears with a real "Install" button, and tapping it actually installs
- [ ] Open on an iPhone (not yet installed) → confirm the banner shows Share → Add to Home Screen instructions instead (no fake install button)
- [ ] Dismiss the banner (×) → confirm it doesn't reappear same day
- [ ] Already-installed device → confirm the banner never shows at all

## 11. General regression (quick spot-check, not exhaustive)

- [ ] Worker: check in, checklist, inventory count still work normally
- [ ] Stand Lead: My Team, Add Stock Myself still work
- [ ] Supervisor: All Stands Live clock-out still works
- [ ] NPO group login still works
- [ ] Warehouse Employee: Transfers tab (assigned tasks) still works, unaffected by any of today's changes

---

## Notes / bugs found

*(use this space — copy a row, note what broke and how)*

| # | Section | What happened | Expected |
|---|---|---|---|
| | | | |
