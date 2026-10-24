-- Premium department — its own locations (suites/clubs you name), and who
-- covers each one. New, additive tables. Nothing existing reads or depends
-- on these, and they're never joined against concession's `stands`,
-- `inventory_entries` or `schedule` tables — Premium stays structurally
-- separate the same way Warehouse and NPO are. Safe to re-run.

create table if not exists premium_locations (
  id bigint generated always as identity primary key,
  name text not null unique,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

alter table premium_locations enable row level security;
drop policy if exists "premium_locations_all" on premium_locations;
create policy "premium_locations_all" on premium_locations
  for all using (true) with check (true);

-- Who covers which Premium location(s). Same shape as zone_assignments,
-- but opposite default: "no row for this person" = unassigned = sees
-- NOTHING (a Premium account with no assignment yet shouldn't default to
-- full visibility the way an unassigned warehouse worker does).
create table if not exists premium_assignments (
  id bigint generated always as identity primary key,
  employee_id text not null unique,   -- last-5-digit ID, same as everywhere else in this app
  name text not null default '',
  role text not null default 'premium_employee',  -- 'premium_employee' or 'premium_manager'
  locations jsonb not null default '[]'::jsonb,    -- array of premium_locations.name strings
  updated_at timestamptz not null default now()
);

alter table premium_assignments enable row level security;
drop policy if exists "premium_assignments_all" on premium_assignments;
create policy "premium_assignments_all" on premium_assignments
  for all using (true) with check (true);

-- What's currently filled at each Premium location. Deliberately NOT a
-- ledger/history — one row per location, overwritten on every save, same
-- "current state, not a log" shape as premium_assignments. Own table;
-- never touches concession's inventory_entries.
create table if not exists premium_stock (
  id bigint generated always as identity primary key,
  location_name text not null unique,
  items jsonb not null default '[]'::jsonb,   -- [{name, qty}]
  notes text not null default '',
  filled_by text not null default '',
  updated_at timestamptz not null default now()
);

alter table premium_stock enable row level security;
drop policy if exists "premium_stock_all" on premium_stock;
create policy "premium_stock_all" on premium_stock
  for all using (true) with check (true);
