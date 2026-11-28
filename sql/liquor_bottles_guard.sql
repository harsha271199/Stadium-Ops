-- Liquor bottles: server-side guard (fix-131).
-- The app only ever changes a bottle's STATUS (open -> empty / void, and a
-- 5-minute Undo). This trigger makes the database refuse anything else, so a
-- bug, an old phone or a hand-made request can't rewrite history:
--   * no deletes
--   * sticker number, bottle, location, roll, who/when tagged, note: fixed after tagging
--   * a voided bottle stays voided; an emptied bottle can only be reopened
--     within 15 minutes (the app's Undo is 5) and its empty details are fixed
create or replace function liquor_bottles_guard() returns trigger
language plpgsql as $$
begin
  if tg_op = 'DELETE' then
    raise exception 'Liquor bottles cannot be deleted — void it with a reason';
  end if;
  if new.sticker_no is distinct from old.sticker_no or new.item_name is distinct from old.item_name
     or new.location is distinct from old.location or new.roll_color is distinct from old.roll_color
     or new.issued_at is distinct from old.issued_at or new.issued_by is distinct from old.issued_by
     or new.client_uuid is distinct from old.client_uuid or new.event_date is distinct from old.event_date
     or new.note is distinct from old.note then
    raise exception 'Bottle details cannot be changed after tagging — void it and tag again';
  end if;
  if old.status = 'void' and (new.status <> 'void' or new.void_reason is distinct from old.void_reason) then
    raise exception 'A voided bottle cannot be changed';
  end if;
  if old.status = 'empty' and new.status = 'open'
     and (old.emptied_at is null or old.emptied_at < now() - interval '15 minutes') then
    raise exception 'An emptied bottle can only be reopened (Undo) within 15 minutes';
  end if;
  if old.status = 'empty' and new.status = 'empty'
     and (new.emptied_at is distinct from old.emptied_at or new.emptied_by is distinct from old.emptied_by
          or new.empty_uuid is distinct from old.empty_uuid) then
    raise exception 'Empty details cannot be changed';
  end if;
  return new;
end $$;

drop trigger if exists liquor_bottles_guard on liquor_bottles;
create trigger liquor_bottles_guard before update or delete on liquor_bottles
  for each row execute function liquor_bottles_guard();
