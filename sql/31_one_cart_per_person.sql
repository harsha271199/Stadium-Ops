-- fix-175: one golf cart per person.
-- A driver could take a second key while still holding one (the app only
-- stopped two people grabbing the SAME key). This makes the database refuse
-- a second checked-out key for the same employee, so it also holds for old
-- cached copies of the app. Returning, flagging or "available" rows are not affected.
create unique index if not exists cart_keys_one_per_person
  on public.cart_keys (checked_out_by_id)
  where status = 'checked_out' and checked_out_by_id is not null;
-- UNDO: drop index if exists public.cart_keys_one_per_person;
