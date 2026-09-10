# Stadium Ops Platform

Game-day concessions operations for Aramark Sports + Entertainment at Arizona State University.

**Live:** [asu-aramark.netlify.app](https://asu-aramark.netlify.app)

Replaces paper checklists, inventory count sheets, stock requests and break time sheets with a phone app that works in a stadium concourse on bad WiFi.

---

## What it does

| Area | What it covers |
|---|---|
| **Attendance** | Check-in/out, breaks, walk-ins, moving staff between stands, present/absent |
| **Inventory** | Count In / Transfer / Count Out per stand, printable report matching the paper form |
| **Requests** | Stock from warehouse, food delivery, IT/POS issues, refund assistance, maintenance |
| **Warehouse** | Delivery queue, QR-scan-to-open, force restock, transfer sign-off chain |
| **Checklists** | Opening / during-event / closing, food safety temps |
| **NPO groups** | Separate login and roster for non-profit volunteer groups |
| **Records** | Break time sheet, tip-distribution CSV, feedback and food-safety history |

---

## Venues

| Venue | Notes |
|---|---|
| Mountain America Stadium | Football — ~68 stands |
| Sun Devil Soccer Stadium | Soccer |
| Desert Financial Arena | Volleyball — DFA 111, DFA 143, DFA 191 |

---

## Architecture

Deliberately simple, because it has to be debuggable at 7pm on a Saturday:

- **Frontend** — one self-contained `index.html`. No build step, no framework, no bundler. Vanilla HTML/CSS/JS.
- **Backend** — Supabase (Postgres + PostgREST). The app talks to it directly through a thin `sb()` wrapper.
- **Hosting** — Netlify, static.
- **Offline** — service worker (`sw.js`), network-first with cache fallback. Writes queue and retry when WiFi returns.
- **Push** — Web Push via a Supabase Edge Function.

### Files

```
index.html      The entire app
sw.js           Service worker — offline fallback + push notifications
manifest.json   PWA manifest (install to home screen)
_redirects      Netlify SPA routing
_headers        Cache rules — index.html and sw.js must never be cached
icon-192.png    App icon
icon-512.png    App icon
```

---

## Roles and login

| Role | ID field | Name field |
|---|---|---|
| Worker / Stand Lead / Supervisor / Bartender | last 5 digits of their real employee ID | their last name |
| Manager / Support Manager / Admin | `90000` | their last name |
| Warehouse (all levels) | `60000` | their last name |
| NPO Group Leader | group selection | group PIN |

Access is checked in the app **and** the shape of each role's screen differs — Support Manager, for example, is deliberately blocked from Inventory and Records at the code level, not just hidden from the menu.

---

## Deploying

No build step. Drag the folder contents into Netlify, or push to `main` if the repo is connected.

**Every deploy must include `index.html` and `sw.js` together.** They're versioned as a pair via `BUILD_TAG`.

### Before deploying

1. Bump `BUILD_TAG` at the top of the `<script>` block in `index.html`
2. Check for syntax errors:
   ```bash
   node -e "const c=require('fs').readFileSync('index.html','utf8');
   [...c.matchAll(/<script(?:\s+[^>]*)?>(.*?)<\/script>/gs)].forEach((m,i)=>{
     if(m[0].includes('jsdelivr'))return;
     try{new Function(m[1]);console.log(i,'OK')}catch(e){console.log(i,'ERROR:',e.message)}});"
   ```
3. Confirm `BUILD_TAG` shows on the login screen footer after deploy — that's how you verify what's actually live

### Testing locally

```bash
python3 -m http.server 8000
```
Then open `http://localhost:8000`. Use a real local server rather than opening the file directly — the service worker and PWA install won't work from `file://`.

---

## Working on this safely

Most production incidents on this project have come from process, not code:

- **One source of truth.** This repo. Never edit a copy someone handed you without checking it against `main` first — fixes have been silently lost that way.
- **Don't deploy on game day.** Test the day before.
- **`BUILD_TAG` is the truth.** If someone reports a bug, check what build their phone actually shows before debugging.

### Hard-won rules

These are all real bugs that reached production:

- `create table if not exists` is a no-op on an existing table — use `alter table ... add column if not exists`
- Postgres runs UTC; the stadium is Arizona. Any `current_date` default needs `at time zone 'America/Phoenix'`
- ReadyOn schedule exports sometimes label a location with a short name (`SOCCER`) that doesn't match the real stand (`Sun Devil Soccer Stadium`). Everyone at that stand then gets blank screens with no error. The upload screen now warns loudly about unmatched locations — **read that warning.**
- Never hardcode a stand list in the app. It goes stale the moment a stand is added or renamed, and fails silently.
- Any submit button that writes a record needs `withLock()` **and** a client-side UUID generated once when the form opens — not per tap. Generating it per tap defeats the database's duplicate protection entirely.
- Surface errors on screen. Nobody has devtools open on a concourse.

---

## Database

Supabase project `mkuylfuhtsfqhyjbjopo`, 38 tables. All use an open `anon` policy — access control is enforced in the app, not by RLS.

Tables worth knowing:

| Table | Holds |
|---|---|
| `stands` | Every stand and its venue. The join key everywhere is `stand_name` — exact string match. |
| `schedule` | Who works where, per event date |
| `attendance` | Check-in/out/break events. `entry_date` is the game day. |
| `stand_sheets` | Per-stand item catalog (~3,100 rows) |
| `inventory_entries` | Submitted Count In / Transfer / Count Out |
| `stock_requests` / `kitchen_requests` / `it_issues` | The three request types |
| `transfers` / `transfer_items` | Warehouse deliveries and force restock |
| `employee_directory` | Full roster for walk-in type-ahead search |
| `npo_groups` / `npo_members` | Volunteer groups. `npo_groups.stand` is comma-joined for multi-stand groups. |

Handy checks:

```sql
-- Which stands never submitted Count Out for a date
select stand from inventory_entries where entry_date = '2026-09-05'
  and phase = 'Count In'
except
select stand from inventory_entries where entry_date = '2026-09-05'
  and phase = 'Count Out';

-- Locations in the schedule that don't match a real stand
-- (this is the failure that silently breaks a game day)
select distinct s.location from schedule s
left join stands st on st.stand_name = s.location
where st.id is null and s.event_date = current_date;
```
