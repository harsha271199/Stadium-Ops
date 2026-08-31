-- Zone Assignments — who covers which stands.
-- New, additive table. Nothing existing reads or depends on this, and
-- everything that DOES read it treats "no row for this person" as
-- "unassigned = sees everything", i.e. today's current behavior, unchanged.
-- Safe to re-run.

create table if not exists zone_assignments (
  id bigint generated always as identity primary key,
  employee_id text not null unique,   -- last-5-digit ID, same as everywhere else in this app
  name text not null default '',
  role text not null default 'warehouse',  -- 'warehouse' or 'supervisor'
  stands jsonb not null default '[]'::jsonb,  -- array of stand name strings
  updated_at timestamptz not null default now()
);

alter table zone_assignments enable row level security;

drop policy if exists "zone_assignments_all" on zone_assignments;
create policy "zone_assignments_all" on zone_assignments
  for all using (true) with check (true);
