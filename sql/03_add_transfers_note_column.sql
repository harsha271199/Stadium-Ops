-- Adds an optional audit-note column to transfers. Not required for
-- deliveries to work — the app already retries without this column if
-- it's missing — but without it, notes like "delivered without QR scan,
-- approved by X" or "scan skipped" are silently dropped every time
-- instead of being kept on the record.
--
-- Safe to re-run.

alter table transfers add column if not exists note text;
