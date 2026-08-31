# Stadium Ops Platform — Full Export

Hand this whole zip to any AI assistant (ChatGPT, another Claude chat, anything) to bring it up to speed on this project from zero.

## Start here
1. **`docs/PROJECT_HANDBOOK.md`** — read this first. Full system explanation.
2. **`app/index.html`** — the live app. Check `BUILD_TAG` near the top of the script block to confirm version.
3. **`sql/`** — every real migration, numbered in the order to run them. `sql/diagnostics/` has reusable verification queries, not one-time migrations.

## ⚠️ Not a full schema dump
The `sql/` folder only has migrations built during actual chat sessions. Base tables (`stands`, `schedule`, `transfers`, `staff_accounts`, etc.) were created earlier and aren't fully documented here at the column level. For a complete schema, run this in Supabase's SQL editor and include the output alongside this zip:

```sql
select table_name, column_name, data_type, is_nullable
from information_schema.columns
where table_schema = 'public'
order by table_name, ordinal_position;
```

## Deployment
Live at `https://asu-aramark.netlify.app/`. If connected to GitHub, pushing `app/index.html` to `main` auto-deploys.
