# Stadium Ops Platform — Full Project Handbook

**Read this first.** Then check `index.html`'s `BUILD_TAG` constant (near the top of the `<script>` block) to confirm the exact version — should read `2026-08-30-fix-print-num-undefined-1` or later.

---

## PART 1 — GitHub workflow

- Live site: `https://asu-aramark.netlify.app/`
- If connected to GitHub, every push to `main` auto-deploys via Netlify — no manual dragging into Netlify's UI needed.
- **Starting any new chat**: give it this doc + `app/index.html` (or the GitHub raw URL once set up). Never trust a chat's memory of "the current file" — only an actual fetched/uploaded file is ever the truth.
- **Ending a session**: get the updated `index.html`, push it to GitHub (or re-upload manually), then update this doc and push that too.

---

## PART 2 — What this is

Single-file vanilla HTML/CSS/JS PWA replacing paper workflows for Aramark concessions at **Mountain America Stadium** (ASU) and **Sun Devil Soccer Stadium**. Supabase/Postgres backend, Netlify hosting. `index.html` is ~11,300+ lines, everything in one file.

Person running this: Harsha Kagithoju. Tests live on a deployed phone build during real events, reports bugs via screenshots. Wants things simple, fast, and forgiving of real-world messiness (late-running games, imperfect CSV exports, non-tech-savvy game-day staff).

---

## PART 3 — Every role

| Role | Login | Access |
|---|---|---|
| Worker | last-5-digit ID + last name | Check in/out, breaks, checklists, inventory — own stand |
| Stand Lead | same | + Requests, Food Safety, My Team — own stand |
| Portable-stand upgraded worker | same | Stand-Lead-level minus Add Walk-in/Request Move. Only on non-main stands with `lead_access_for_all=true`. **OFF blocks login outright** for non-leads — not just a downgrade. |
| Supervisor | same | All-stands Live, unified Request Stock/IT (stand picker), Checklists & Inventory Status, Stand Transfer Record, My Team (any stand) |
| Support Manager | shared code `90000` + last name | Overview only: Roster, Stock, IT, Live. Shown as "Manager" on screen — tier is backend-only. |
| Manager | same shared code | + Inventory, Records. No Admin. |
| Admin | same shared code | Everything, including Admin tab |
| Warehouse Employee | PIN | Only "To Deliver" + Cart |
| Warehouse Supervisor | PIN | Full Transfers/Requests + Cart |
| Warehouse Manager | PIN | Everything: Transfers, Requests, Inventory, Cart admin, Zone Assignments |
| NPO Group Leader | group + PIN | Roster present/absent, requests, checklists |
| Golf cart driver | own last-5 ID | Separate list, not role-based |

**Manager login is entirely database-driven** — no hardcoded code in the app. Each manager has a real 8-digit `employee_id` ending in `90000` in `staff_accounts`, matched by last-5-digit suffix, exactly like every worker. Tier (`support_manager`/`manager`/`admin`) is a plain field, changeable with one SQL line.

---

## PART 4 — Major systems

### Multi-shift scheduling (the big one this session)
- A person can now have **more than one schedule row on the same day** — needed for a stand lead/supervisor working both a morning and evening game. Unique constraint is `(employee_id, event_date, event_name, start_time)`.
- **Real "Batch 1 / Batch 2" cutover** (`selectShiftBatch()`): when a stand has multiple distinct shift windows scheduled the same day, the roster (My Team, Manager/Supervisor Roster view) automatically switches crews at the **exact midpoint** between one shift ending and the next starting — no hardcoded cutoff time. For a 1PM-end/5PM-start day, that's exactly 3:00 PM. Verified against real data before shipping.
- This is computed **per stand** (Roster view covers every stand at once — different stands can run different shift patterns the same day) and applies to **every person**, not just ones with multiple rows — a worker with only one shift today still gets filtered out once their shift window has passed.
- CSV upload (`adminUploadSchedule`) auto-detects the real header row (ReadyOn exports have 4 metadata lines before it), converts Excel-forced-text dates and 12-hour times, and upserts safely instead of hard-failing on any duplicate.
- **Real bug fixed**: the CSV's "Location" column is often just a generic department label ("ASU Athletics"), not a real stand — "Site" is the actual venue and now takes priority.

### Delivery / Warehouse (heavily reworked)
- Stock requests merge directly into the real per-item checklist (not a separate "confirm all" blob).
- Stand-to-stand transfers auto-populate the report's S-to-S columns — no manual re-entry.
- QR scanning: scan-to-open (`?scan=<stand>`), scan-to-confirm-delivery, and scan-to-force-stock (in-app camera) all reuse the same working code and the same real URL scheme.
- No manager-approval chain for stand requests/force-stock — only a genuine manager-created transfer goes through Supervisor→Manager sign-off.
- `ensureActiveTransfer()` — new work on an already-completed stand starts a fresh batch instead of writing into the immutable old one.

### Inventory report
- Full catalog always shows (blank rows for uncounted items), correct paper-matching order, correct venue per stand, real On-Hand/Restock columns, two-tier header matching the physical form exactly, 12 rows/page/landscape.
- Uncounted Count Out shows a computed "(exp)" expected value instead of a bare dash.
- **Carry-forward**: submitting a Count Out automatically updates that stand's catalog (`stand_sheets.on_hand`/`exp_start`) so the next event starts from the real physical count, not the original static number.
- Print function wrapped in try/catch — any failure shows a real, copyable error message in the popup instead of a silent blank page.
- Sticky bottom bar (Urgency/Send on Request Stock, Submit on Inventory Count) — no more scrolling through 60 items to reach the action button.

### Portable Stand Access
- `stands.lead_access_for_all`, admin-tab-only toggle, scoped to `is_main_stand=false` so it can never affect a real stand's normal workforce.

---

## PART 5 — Data conventions

- **Stand names are the literal join key everywhere** — a mismatch (even trailing whitespace) silently breaks things. The report-building code now normalizes/trims stand names defensively.
- **`stand_sheets`** = the per-stand item catalog (name, unit, pack, on_hand, exp_start, chargeable, category). Both Request Stock and Inventory Count read from this exact same table.
- **`is_main_stand`** on `stands` — distinguishes real named stands from portable/cart ones.
- Manager tiers live in `staff_accounts.role`.
- `schedule` now allows multiple rows per person per day (see Part 4).

---

## PART 6 — Known open items

- Waste/Comp/Return are still one combined "Waste" field at data-entry time — the report shows separate boxes matching the paper form, but Comp/Return will print blank until the Count Out screen itself is changed to capture them as three separate numbers.
- `screen-stock-other` (Warehouse's own "for a stand" button) still has a free-text stand field, not a dropdown — real typo risk since stand names are the join key.
- Supervisor cross-venue force-stock tools (acting on any stand's stock, not just their own) — flagged, not built.

---

## PART 7 — How to resume in any chat
1. Upload/fetch `app/index.html` + this doc together.
2. Confirm `BUILD_TAG` matches before touching anything.
3. Say what you want to work on.
4. At the end, get an updated version of this doc and push both files back to GitHub.
