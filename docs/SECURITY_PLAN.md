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
