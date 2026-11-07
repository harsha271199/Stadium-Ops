-- 🍾 Premium liquor bottles (fix-121/122). Sticker-numbered bottles: tagged -> empty.
create table if not exists liquor_bottles (
  id bigserial primary key,
  sticker_no text not null,
  roll_color text not null default '',
  item_name text not null,
  location text not null default '',
  status text not null default 'open' check (status in ('open','empty','void')),
  event_date date,
  issued_at timestamptz not null default now(),
  issued_by text not null default '',
  emptied_at timestamptz,
  emptied_by text,
  empty_uuid text unique,          -- marks the scan that emptied it (retry-safe)
  void_reason text,
  note text,
  client_uuid text unique,         -- marks the scan that tagged it (retry-safe)
  updated_at timestamptz not null default now()
);
-- one open bottle per sticker number at a time
create unique index if not exists liquor_bottles_open_sticker on liquor_bottles (sticker_no) where status = 'open';
create index if not exists liquor_bottles_loc on liquor_bottles (location, status);
alter table liquor_bottles enable row level security;
-- read / add / update only: the app can never DELETE a bottle row.
drop policy if exists anon_all_liquor_bottles on liquor_bottles;
drop policy if exists anon_sel_liquor_bottles on liquor_bottles;
drop policy if exists anon_ins_liquor_bottles on liquor_bottles;
drop policy if exists anon_upd_liquor_bottles on liquor_bottles;
create policy anon_sel_liquor_bottles on liquor_bottles for select to anon using (true);
create policy anon_ins_liquor_bottles on liquor_bottles for insert to anon with check (true);
create policy anon_upd_liquor_bottles on liquor_bottles for update to anon using (true) with check (true);

-- Insert-only history: every tag / empty / undo / void / rejected scan.
create table if not exists liquor_bottle_events (
  id bigserial primary key,
  bottle_id bigint,
  sticker_no text not null,
  action text not null,
  item_name text,
  location text,
  who text not null default '',
  note text,
  at timestamptz not null default now(),
  client_uuid text unique
);
create index if not exists liquor_bottle_events_sticker on liquor_bottle_events (sticker_no, at);
alter table liquor_bottle_events enable row level security;
drop policy if exists anon_read_liquor_bottle_events on liquor_bottle_events;
drop policy if exists anon_insert_liquor_bottle_events on liquor_bottle_events;
create policy anon_read_liquor_bottle_events on liquor_bottle_events for select to anon using (true);
create policy anon_insert_liquor_bottle_events on liquor_bottle_events for insert to anon with check (true);

-- Pre-printed rolls still in use: pink #48 (new) and green #075 (old).
insert into app_settings (key, value) select 'liquor_sticker_rolls', '[{"from":1592001,"to":1593000,"color":"Pink","roll":"48"},{"from":2037001,"to":2038000,"color":"Green","roll":"075"}]'
where not exists (select 1 from app_settings where key='liquor_sticker_rolls');
