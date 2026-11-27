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
| — | Lock staff account changes: create/edit logins only through `staff_account_write` (Admin: PIN; warehouse manager/supervisor: last name, temp-worker add only) | **Built (fix-172b), not live.** Order: upload build → check Admin → Access save + a warehouse temp add → run `sql/28_security_step2_GO_LIVE.sql`. Undo `sql/28_security_step2_UNDO.sql` + previous zip |
| ? | "Last-5 IDs" step from the original plan (deferred until after the season) — details to be re-confirmed with Harsha | Not started |

Other notes:
- The Admin PIN is short; change it to a longer, less common one in Admin → Access.
- Every other table (schedule, attendance, inventory, transfers…) is still writable
  with the public key — the app has no per-user server sign-in yet. That is the
  bigger long-term item.
