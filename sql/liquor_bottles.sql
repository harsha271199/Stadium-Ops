-- 🍾 Premium liquor bottles (fix-121). Sticker-numbered bottles: tagged -> empty.
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
  void_reason text,
  note text,
  client_uuid text unique,
  updated_at timestamptz not null default now()
);
-- one open bottle per sticker number at a time
create unique index if not exists liquor_bottles_open_sticker on liquor_bottles (sticker_no) where status = 'open';
create index if not exists liquor_bottles_loc on liquor_bottles (location, status);
alter table liquor_bottles enable row level security;
drop policy if exists anon_all_liquor_bottles on liquor_bottles;
create policy anon_all_liquor_bottles on liquor_bottles for all to anon using (true) with check (true);
-- sticker rolls in use: pink #48 (new) and green #075 (old)
insert into app_settings (key, value) select 'liquor_sticker_rolls', '[{"from":1592001,"to":1593000,"color":"Pink","roll":"48"},{"from":2037001,"to":2038000,"color":"Green","roll":"075"}]'
where not exists (select 1 from app_settings where key='liquor_sticker_rolls');
