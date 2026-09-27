# QA Progress — Stadium Ops Regression Audit

## Environment constraint (read this first)

This session's sandbox cannot reach either `asu-aramark.netlify.app` or Supabase's
raw REST endpoint (`mkuylfuhtsfqhyjbjopo.supabase.co`) over HTTPS. Confirmed
independently via `curl`, `playwright-cli`, and the built-in `WebFetch` tool — all
three hit the identical `EGRESS_BLOCKED` / "gateway answered 403 to CONNECT
(policy denial)" response. This is an organization-level network policy on this
sandbox, not a tool bug, and not something any browser-automation tool can route
around — retrying or switching tools doesn't help.

**What does work:** the Supabase MCP connector (`mcp__Supabase__*`), which reaches
the database through its own service-level path rather than generic HTTPS egress.
That gives real, live read access to production data (used read-only so far) and
lets me replay the app's actual PostgREST-style queries as plain SQL to verify
data-layer logic exactly as the app would see it.

**Methodology used instead of live browser clicks:**
1. **Code trace** — read the exact function that handles a role/action/permission
   check in `index.html`, verified against its call sites.
2. **Data verification** — run the same filter the app's `sb()` call would send,
   via `mcp__Supabase__execute_sql`, against real (read-only) or QA-tagged
   (`is_test=true`) data, to confirm the query returns what the code assumes.
3. Anything that requires actually watching pixels render or clicking through
   the live UI is marked `BLOCKED — no network access` in `tests.json`, not
   guessed at.

## Urgent, unrelated finding (flagged to user 2026-09-27)

No `schedule` rows exist for today (2026-09-27) as of this audit. Last real game
data on file is 2026-09-05. If a game is happening tonight, the roster upload is
still pending — this is independent of the QA work below and was raised
immediately when found.

## Fixes already made and deployed this session (before this audit's tests.json existed)

- `2026-09-27-stock-fallback-notify-1` — Stock request fallback push now
  includes Warehouse Manager + Supervisor, not just Warehouse Employee.
- `2026-09-27-notify-audit-1` — Delivery-ready-to-verify push falls back to
  Warehouse Manager when no Supervisor is on shift.

## Status

In progress. See `tests.json` for the full matrix and per-test status.
