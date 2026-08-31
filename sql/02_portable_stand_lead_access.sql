-- Portable/outside-stand lead-equivalent access.
-- Adds one flag to the stands table. Default is false everywhere, so
-- nothing changes for any existing stand until you explicitly flip one on.
-- Safe to re-run.

alter table stands add column if not exists lead_access_for_all boolean not null default false;

-- Once you know which stands need this (portable bars, off-site booths,
-- anywhere without a dedicated Stand Lead physically present), turn it on
-- per stand like this — no app redeploy needed, this takes effect the
-- next time someone at that stand logs in:
--
--   update stands set lead_access_for_all = true where stand_name = 'Portable Bar 1';
--
-- To turn it back off for a stand:
--
--   update stands set lead_access_for_all = false where stand_name = 'Portable Bar 1';
--
-- To see which stands currently have it on:
--
--   select stand_name from stands where lead_access_for_all = true;
