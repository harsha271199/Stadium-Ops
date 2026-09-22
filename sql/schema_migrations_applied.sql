-- Schema changes applied to the live Supabase project (mkuylfuhtsfqhyjbjopo)
-- during recent work. These have ALREADY been run in production — this file
-- documents them so the repo reflects the real database state. Safe to
-- re-run (all use IF NOT EXISTS / idempotent patterns).

-- ── stand_sheets: explicit display order ──
-- Inventory display order must match each stand's real paper form, not
-- database insertion order. Populated per-stand; Soccer was corrected by
-- name to its printed 1-60 sequence.
alter table stand_sheets add column if not exists sort_order integer;

-- ── stand_sheets: add-on marker ──
-- Flags items added after a stand's original printed sheet (e.g. handwritten
-- extras). Used to render an "added after original sheet" divider in the app
-- and reports.
alter table stand_sheets add column if not exists is_addon boolean default false;

-- ── cart_inspections: enable RLS ──
-- This table previously had no row-level security at all, unlike every other
-- table. Enabled with an open anon policy matching the rest of the app.
alter table cart_inspections enable row level security;
-- (policy "anon_all_cart_inspections" created for all/anon using(true) with check(true))

-- ── employee_directory: full roster for walk-in search ──
-- See load_employee_directory.sql for the table definition and how to load
-- the full ReadyOn roster. Enables type-ahead search when adding a walk-in
-- so staff don't have to recall an exact 8-digit ID.

-- ── stands: venue-scoped stands ──
-- Desert Financial Arena stands (DFA 111 / 143 / 191) added under venue
-- 'Desert Financial Arena'. Sun Devil Soccer Stadium under its own venue.
-- The app scopes the stand picker to today's venue, worked out from the
-- day's schedule, so a supervisor only sees that night's stands.
