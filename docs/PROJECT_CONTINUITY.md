# Stadium Ops Platform — Continuity Doc
**Current build: `2026-08-26-restore-locked-state-and-deliver-btn`** (check this against the login screen footer or `grep BUILD_TAG index.html` before trusting anything below — if they don't match, this doc is stale)

## ⚠️ How to use this doc
Two chats have been working on this same file in parallel this week — that's the actual cause of "data reverting" and confusion, not a bug. Going forward:
- **Upload BOTH this doc AND the current `index.html` together, every time**, whichever chat you're in.
- Whichever chat you *didn't* just use is blind to what the other did. Never assume a chat remembers the file — only an uploaded file is ever truth.
- If you can, do all future work in **one** chat. If you can't, always cross-upload the other chat's latest file before continuing in either one.
- At the end of any real session, ask for this doc to be regenerated before you close the chat.

---

## What this app is
Stadium Ops Platform — single-file vanilla HTML/CSS/JS PWA for Aramark concessions at Mountain America Stadium + Sun Devil Soccer Stadium. Supabase/Postgres backend, Netlify hosting (`asu-aramark.netlify.app`).

## Access tiers, all confirmed working as of this build

| Tier | Login | Access |
|---|---|---|
| Worker | last-5-digits + last name | check in/out, breaks, checklists, inventory |
| Stand Lead | same | + Requests, Food Safety, My Team |
| Portable-stand upgraded (bartender etc.) | same | Same as Stand Lead **minus** Add Walk-in Worker + Request Worker Move. Granted per-stand via Admin → Portable Stand Access toggle. Non-main stands only — toggle OFF blocks login outright for non-leads, doesn't just downgrade to worker. |
| Supervisor | same | All-stands Live, unified Request Stock/Report IT with a stand picker, Checklists & Inventory Status, Stand Transfer Record |
| Support Manager | shared code `97531` + real last name | Overview only (Roster/Stock/IT/Live), no Inventory/Records/Admin |
| Manager | same shared code | Everything except Admin |
| Admin (you) | same shared code | Everything, including Admin tab |
| Warehouse Employee | PIN login | **Only** "To Deliver" (merged transfers+requests) + Cart |
| Warehouse Supervisor | PIN login | Full Transfers/Requests + Cart |
| Warehouse Manager | PIN login | Everything, including Zone Assignments, Portable Stand Access, Cart driver admin |

## Today's real fixes, in order (don't re-investigate these — they're closed)

1. Zone assignments — supervisors/warehouse employees can be scoped to specific stands (My Stands/All Stands toggle)
2. Golf cart return redesign — no-issue returns auto-free the key, issues flag the cart for manager review, no blanket manager approval needed
3. Manager quick-login (shared code, no personal PIN)
4. Portable stand lead-access toggle — **moved to Admin tab, admin-only**, was originally in Warehouse Manager (wrong place, fixed)
5. Unified Request Stock / Report IT screens — one screen each, stand picker for anyone without a fixed home stand, no more "for another stand" framing
6. Warehouse Employee simplified to "To Deliver" + "Cart" only, Transfers/Requests hidden entirely for that role
7. **Delivery completion overhaul** — stock requests now merge into the real per-item checklist (not a blind "confirm all" button), closing a request now actually happens, QR re-scan-to-confirm (or skip) added, no manager approval chain for stand-requested/force-stocked deliveries (only real manager-planned transfers go through supervisor+manager sign-off)
8. **Just fixed — three compounding bugs in the delivery screen**, found by the other chat and ported here:
   - Opening a stand could land on an already-finished transfer instead of an active one
   - The "locked" check didn't recognize `delivered` status (only `verified`/`confirmed`) — a finished delivery stayed editable
   - Same bug on the deliver button — stayed clickable after completion, inviting a duplicate completion attempt
   - Small fix: force-stocking onto a manager-created-but-untouched transfer now correctly flips it to `delivering`

## Known, deliberately unfixed — needs your decision, not a guess

- **`screen-stock-other` (Warehouse's "➕ New stock request for a stand" button) still uses a free-text stand name field**, not a dropdown. Since stand names are the literal join key everywhere, a typo here silently misroutes the request. Flagged twice now (by both chats) — fix it (convert to dropdown, same pattern used elsewhere) or leave it (maybe intentional for a stand not yet catalogued)? Your call.
- Quick-add chips for force-stock (`tsQuickAddDirect`) — a nicety from the other chat, not built here yet.
- Supervisor cross-venue force-stock tools (`supActiveStand`, `goSupForceStock`, `gsFromStand`) — exist in the other chat's lineage, not built here. Feature gap, not a bug.

## Two separate "claim" systems — don't conflate these if a bug report mentions "claim"
1. **Stock-request delivery** — inside the per-stand screen (`openTransferStand`), items just merge and get checked off, no separate claim step anymore.
2. **Task-assignment claim** (✋ Claim button) — on the Transfers list, for unassigned force-stock transfers. `whClaimTransfer`. Untouched, unrelated code path.

## Data conventions that matter
- Stand names are the join key everywhere (`transfers.stand`, `stock_requests.stand`, `stands.stand_name`) — not IDs. A mismatched name silently breaks things downstream.
- `is_main_stand` (on `stands`) distinguishes real named stands from portable/cart ones — used to scope the portable-access login rule so it can never lock out a main stand's normal workforce.
- `lead_access_for_all` (on `stands`) — the portable-stand toggle itself.
- Manager tiers live in `staff_accounts.role`: `support_manager` / `manager` / `admin`, all using the same shared quick-code.

## Pending SQL — confirm these have actually been run
- `zone_assignments_table.sql`
- `portable_stand_lead_access.sql`
- `add_transfers_note_column.sql`
- Manager roster SQL (support_manager/admin tier assignments)
- Bartender Beer Portable schedule SQL

## How to resume in a new or existing chat
1. Upload this doc + the current `index.html` together.
2. Say what you want to work on.
3. If something specific from before isn't captured here, ask to search past chats — pulls the real transcript, not a summary.
