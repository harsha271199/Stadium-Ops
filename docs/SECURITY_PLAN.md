# Security plan (kept here so it survives long chats)

How people sign in (11/27, confirmed by Harsha):
- **Everyone** signs in with a 5-digit code (last 5 of their employee ID, or a
  shared code such as 60000 warehouse / 70000 premium / 90000 managers / 50000
  subcontractors) + **last name**.
- **Only Admin (Harsha)** signs in with an ID + PIN.
- **NPO groups** sign in with their group PIN + their name on the group list.

| Step | What | Status |
|---|---|---|
| 1 | Hide staff PINs from the public website key (sign-in checks PINs inside the database) | **Live 11/24** — `sql/27_security_step1_hide_pins.sql`, undo `sql/27_security_step1_UNDO.sql` |
| — | Lock staff account changes: create/edit logins only through `staff_account_write` (Admin: PIN; warehouse manager/supervisor: last name, temp-worker add only) | **Live 11/27** (fix-172b + lock). From outside: add/edit/delete staff accounts → 401 refused; Admin and warehouse checks work; all sign-ins work. Undo `sql/28_security_step2_UNDO.sql` |
| ? | "Last-5 IDs" step from the original plan (deferred until after the season) — details to be re-confirmed with Harsha | Not started |

Other notes:
- Admin PIN changed 11/27 (old one refused).
- Every other table (schedule, attendance, inventory, transfers…) is still writable
  with the public key — the app has no per-user server sign-in yet. That is the
  bigger long-term item.

11/27 test of the public key (rolled back): it can still edit, add and delete rows in
schedule, attendance, inventory_entries, stand_sheets, transfers, stock_ledger,
stand_transfers, npo_groups, stands, staff_stand_access, game_day_assignments,
warehouse_roster, premium_schedule, app_settings, kitchen_runner_assignments,
stand_chat, checklists (liquor_bottles: edit/add, no delete). Next: remove DELETE
where the app never deletes; then server-checked sign-in after the season.

## 11/27 — No public deletes (live)
- `sql/29_security_no_public_delete.sql` (undo `sql/29_security_no_public_delete_UNDO.sql`).
- The public key can no longer DELETE in 100 tables the app never deletes from
  (counts, deliveries, ledger, bottles' backups, NPO, settings, stand access, …)
  and can no longer add/edit/delete through the two views. That closed a side
  door: `warehouse_employee_directory` let the public key edit/delete warehouse
  staff accounts despite the staff lock.
- Still deletable (the app needs it): schedule, stand_sheets, attendance,
  stock_requests, it_issues, checkins, active_sessions, game_day_assignments,
  warehouse_roster, transfer_items, premium_schedule, premium_assignments,
  premium_locations, zone_assignments. Edge functions use the server key (unaffected).
- Verified from outside: deletes refused (401); sign-ins 9/9; app deletes still work.

## Next: server-checked sign-in (between seasons)

**Today:** the phone checks your sign-in, then every request uses the same public
key. The database cannot tell Krish from a stranger, so tables accept anyone.

**Change:** sign-in is checked by the server, which hands the phone a signed
"pass" for that person: who they are, their role, which stands, which day,
expires at 6 AM. Every request carries the pass; each table has rules that read it.

Example (DFA 143, Krish, stand lead):
1. Krish signs in (47434 + Shah). The server checks today's schedule and returns
   a pass: Krish · lead · stands [DFA 143] · valid until 6:00 AM.
2. He submits Count Out for DFA 143 → the rule "leads may write counts for their
   own stands" passes → saved.
3. He tries to change app_settings → rule "only admin/manager" → refused.
4. Someone copies the website key and tries to change DFA 143's counts → no pass
   → refused.
5. Matt's pass (warehouse manager) can mark deliveries for any stand, cannot edit
   the schedule. An NPO lead's pass covers only their group's stands.

Rollout (each step tested on a separate staging copy first, then one live event):
1. Server sign-in function + app attaches the pass. No rules yet — nothing
   changes for anyone. (Old sessions sign in once again.)
2. Watch mode for 1–2 events: rules only log what they WOULD refuse; fix any
   legitimate action that would be blocked.
3. Turn rules on table by table: settings / stand access / NPO / staff first,
   then inventory + deliveries, then attendance + schedule.
4. Remove the public key's write access entirely.
Undo at every step: turn the table's rule off (one line), app keeps working.
