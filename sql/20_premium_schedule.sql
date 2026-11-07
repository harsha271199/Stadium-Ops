-- Premium department's own day-of-game roster/check-in table. Deliberately
-- separate from concession's `schedule` table — Premium's Field Box
-- bartenders, Suite attendants etc. are never rows in `schedule`, and
-- concession's stand workers are never rows here. This is what a Premium
-- Manager's Roster tab (present/absent/move/add walk-in) reads and writes.

create table if not exists premium_schedule (
  id bigint generated always as identity primary key,
  event_date date not null,
  employee_id text not null,
  worker_name text not null,
  role_title text not null default '',
  location_name text not null,
  start_time text not null default '',
  end_time text not null default '',
  status text not null default 'scheduled',   -- scheduled | present | absent | checked_out
  is_walkin boolean not null default false,
  checked_in_at timestamptz,
  checked_out_at timestamptz,
  updated_at timestamptz not null default now(),
  unique(event_date, employee_id)
);

alter table premium_schedule enable row level security;
drop policy if exists "premium_schedule_all" on premium_schedule;
create policy "premium_schedule_all" on premium_schedule
  for all using (true) with check (true);
