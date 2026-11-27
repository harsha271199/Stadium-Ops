# Access rules draft (for server-checked sign-in)

*Drafted 2026-11-27. Built from docs/MASTER_ACCESS_LIST.md (9/27) and checked against what the app code actually writes today. These are the rules the pass would enforce in a later step. Step 1 ("pass only") enforces none of them.*

Reading stays as it is today. These rules cover **changes** (add / edit / remove) only.

## Who can change what

| Table (what it holds) | Who can change it | Notes from the code |
|---|---|---|
| attendance, checkins, active_sessions | Anyone signed in, for their own check-in. Lead / Supervisor / Manager / NPO lead for their team | Mark absent, undo absent, photo check-in |
| schedule | Admin (CSV upload). Lead / Supervisor / Manager (walk-in, move worker) | `managerMoveWorker`, walk-ins |
| worker_moves | Lead / Supervisor / Manager | Move worker between stands |
| stock_requests (new) | Anyone signed in at a stand, NPO lead, Supervisor, Manager | Workers order until the 3rd-quarter cutoff |
| stock_requests (status) | Warehouse (all 3), Manager | Claim → on my way → delivered |
| it_issues (new) / (status) | Anyone signed in / Tech, Manager | |
| kitchen_requests | Food team, Food runners, Lead, Supervisor, Manager | |
| kitchen_runner_assignments | Food manager, Manager, Admin | Concession runner areas |
| checklists, food_safety_logs, wastage_logs | Lead, upgraded portable worker, Supervisor, NPO lead, Manager | |
| inventory_entries (counts) | People at that stand (incl. Count-In-only month-end), Supervisor, Warehouse (`whSaveCount`), Manager | |
| stand_sheets (expected counts, Yellow Dog) | Manager, Admin. Lead / Supervisor when sending a stand transfer | `gsSend`, `invAdjustExpected`, YD upload |
| stand_transfers | Lead, Supervisor, Manager | Send / confirm / cancel |
| transfers, transfer_items | Warehouse (all 3), Manager | Warehouse employee only updates delivery status |
| warehouse_roster | Warehouse manager / supervisor (temp add), Admin (upload) | |
| game_day_assignments, coverage_areas, zone_assignments | Warehouse manager, Manager, Admin | Assign & Team |
| staff_stand_access | Admin. **Also Lead / Supervisor / Manager for workers on their team** (My Team → give stand access). Upgraded workers cannot | `canGrantTeamStandAccess` |
| premium_schedule | Premium manager (all), premium employee (own check-in), Admin | |
| premium_locations, premium_assignments | Premium manager, Admin | |
| npo_members | NPO lead (walk-ins), Admin | |
| npo_groups | Admin | |
| cart_log, cart_inspections, cart_keys, cart_verifications | Approved cart drivers, Manager | |
| cart_drivers | Admin | |
| refund_requests | Anyone signed in (new), Manager (approve) | |
| maintenance_reports | Supervisor, Manager | |
| stands, stand flags | Admin only | Portable self-login toggle, open/close stand |
| app_settings | Admin. Manager / Food team for the 3rd-quarter cutoff only | `q3Toggle`, premium team list |
| game_day_content | Admin | |
| staff_accounts | Admin (PIN), Warehouse manager / supervisor temp add only | **Already locked** (step 2) |
| worker_feedback, push_subscriptions, stand_chat, bus_conduct_signatures, on_duty | Anyone signed in | |

## Where the September list is out of date

1. **Warehouse login.** It now uses shared code 60000 + last name, not a PIN.
2. **Tech and Premium employee logins.** The list still says "PIN" for these. You said only Admin uses a PIN, so the list needs updating (to confirm).
3. **Multi-stand access** (staff_stand_access) is missing from the list. Examples: Krish on the West portables, Ebony on the east Santans, the market leads.
4. **Leads and supervisors can give workers access to another stand** from My Team. The list implies only Admin grants access.
5. **The Premium team list** (Terri, Yadzia and others, kept in app_settings) is missing. So are the extra premium managers beyond Nestor and Natasha.
6. **Food manager, food runners and concession runner areas** are not in the list.
7. **Month-end Count-In-only** at closed stands for leads and supervisors is not in the list.
8. **3rd-quarter food/alcohol cutoff.** Managers and the Food team can switch it; it is not in the list.
