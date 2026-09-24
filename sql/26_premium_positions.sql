-- Premium's own name -> position lookup, used by the Add Walk-in search
-- to auto-fill Role instead of someone typing it every time. Separate
-- from the generic `employee_directory` (which has no Premium-specific
-- titles like "Catering Services Supervisor" or "Expo Captain") and
-- separate from `premium_schedule` (that's the day-of roster; this is a
-- standing reference you can keep growing).
--
-- Seeded here from today's already-imported roster (82 people, real
-- positions) so search already works immediately. When the fuller
-- ReadyOn export gets uploaded, re-run an updated version of the insert
-- below (or a new seed file) to add more names — same
-- upsert-by-employee_id shape, safe to re-run.

create table if not exists premium_positions (
  id bigint generated always as identity primary key,
  employee_id text not null unique,
  full_name text not null,
  position text not null default '',
  updated_at timestamptz not null default now()
);

alter table premium_positions enable row level security;
drop policy if exists "premium_positions_all" on premium_positions;
create policy "premium_positions_all" on premium_positions
  for all using (true) with check (true);

insert into premium_positions (employee_id, full_name, position)
select distinct on (employee_id) employee_id, worker_name, role_title
from premium_schedule
where employee_id !~ '^WALKIN-'
order by employee_id, updated_at desc
on conflict (employee_id) do update set
  full_name = excluded.full_name,
  position = excluded.position,
  updated_at = now();
