-- v4 dropped EVERY unique index on the table, including schedule_pkey
-- (the primary key's backing index) — that one must never be dropped,
-- Postgres correctly refused. This version explicitly excludes any index
-- backing a PRIMARY KEY constraint, only touching the de-duplication
-- rule that's actually meant to be replaced.
--
-- Safe to re-run.

-- Drop unique CONSTRAINTS (never touches the primary key — contype='u' only, 'p' is primary key)
do $$
declare cname text;
begin
  for cname in
    select conname from pg_constraint
    where conrelid = 'schedule'::regclass and contype = 'u'
  loop
    execute format('alter table schedule drop constraint %I', cname);
  end loop;
end $$;

-- Drop standalone unique INDEXES only — explicitly excluding anything
-- that backs the primary key (schedule_pkey stays, always)
do $$
declare iname text;
begin
  for iname in
    select indexname from pg_indexes
    where tablename = 'schedule'
      and indexdef ilike 'CREATE UNIQUE INDEX%'
      and indexname not in (
        select conname from pg_constraint
        where conrelid = 'schedule'::regclass and contype = 'p'
      )
  loop
    execute format('drop index if exists %I', iname);
  end loop;
end $$;

-- Add the one correct rule back
alter table schedule add constraint schedule_emp_date_event_time_unique
  unique (employee_id, event_date, event_name, start_time);

-- Verify — should show exactly one row, the new rule:
select conname, pg_get_constraintdef(oid) from pg_constraint
where conrelid = 'schedule'::regclass and contype = 'u';

-- Confirm the primary key is still intact (should show one row, unchanged):
select conname, pg_get_constraintdef(oid) from pg_constraint
where conrelid = 'schedule'::regclass and contype = 'p';
