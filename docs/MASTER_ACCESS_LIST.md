# Stadium Ops Platform — Master Access List
*Confirms exactly what's built today, checked directly against the code, not just described from memory.*

## Manager tier — the three-way split

| Tier | Who | Login | What they see |
|---|---|---|---|
| **Support Manager** | Game-day only helpers — Gaona De Cazares, Byrd, St. John, Burke, Andriyansa, Crnjac, Hernandez | Shared code `90000` + real last name | **Overview only**: Roster, Stock (+ request-for-a-stand), IT, Live (with real clock-out). **No** Inventory, **no** Records, **no** Admin — those sidebar buttons don't render at all for this tier, not just hidden. |
| **Manager** | Anyone promoted to full manager | Same shared code `90000` + real last name | Everything Support Manager has, **plus** Inventory and Records (Reports, Carts, Maintenance, Refunds, Times). **No** Admin. |
| **Admin** | You (Kagithoju) | Same shared code `90000` + real last name | **Everything** — all of Manager, plus the Admin tab: Portable Stand Access toggle, NPO group management, cart driver approval, schedule CSV upload. |

**How the tier is decided**: not the login code (same for all three) — it's each person's `role` field in `staff_accounts` (`support_manager` / `manager` / `admin`), checked at login. To promote or demote someone, that's a one-line SQL update to that field — no code change needed.

---

## Every other role, for the full picture

| Role | Login | Access |
|---|---|---|
| **Worker** | Last 5 digits of ID + last name (from the day's schedule) | Check in/out, breaks, checklists, inventory count — own stand only |
| **Stand Lead** | Same | + Requests (Stock/IT), Food Safety, My Team — own stand only |
| **Portable-stand upgraded worker** (bartender etc.) | Same | Same as Stand Lead, minus Add Walk-in Worker + Request Worker Move. Only applies to stands flagged `lead_access_for_all = true` (Admin toggle), and only non-main stands — a main stand can never be affected by this. |
| **Supervisor** | Same | All-stands Live (with clock-out), Request Stock/Report IT with a stand picker, Checklists & Inventory Status, Stand Transfer Record, My Team for any stand |
| **Warehouse Employee** | PIN (last-5 + 4-digit PIN) | Only "To Deliver" (merged transfers + requests) and "Cart" (self-checkout) |
| **Warehouse Supervisor** | Same | Full Transfers + Requests tabs, plus Cart |
| **Warehouse Manager** | Same | Everything — Transfers, Requests, Inventory, Cart driver admin, Zone Assignments, Portable Stand Access *(this now actually lives under Admin — see note below)* |
| **NPO Group Leader** | Group name + PIN | Roster present/absent, stock requests, checklists — no clock in/out. Multi-stand groups get a picker at login. |
| **Tech** | PIN | IT ticket resolution |
| **Golf cart driver** | Own last-5 ID (separate `cart_drivers` list, not role-based) | Check out a key, daily pre-use inspection |

**Correction to keep in mind**: the Portable Stand Access toggle was originally built under Warehouse Manager, then moved to Admin because it's a genuine access-granting tool and belongs restricted to Admin only. Warehouse Manager still has Zone Assignments and Cart driver admin — just not that specific toggle anymore.

---

## The three real "levels" in plain terms

1. **Support Manager** — walks in on game day, needs the basics (who's here, get stock, report a broken POS, see who's live) and nothing else. Can't accidentally touch inventory records, admin settings, or historical reports.
2. **Manager** — day-to-day operational owner. Everything Support Manager has, plus the deeper record-keeping (inventory history, refunds, timesheets) needed to actually run the operation across a season, not just one shift.
3. **Admin (you)** — the only tier that can change who has access to what. Everyone else operates within a system Admin configures; nobody else can grant themselves more access or add new managers.

This is a strict hierarchy — Admin ⊇ Manager ⊇ Support Manager. Nothing a lower tier can do that a higher tier can't.
