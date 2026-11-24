-- UNDO for 27_security_step1_hide_pins.sql: lets the public key read every
-- staff_accounts column again (the state before 2026-11-24).
grant select on public.staff_accounts to anon, authenticated;
