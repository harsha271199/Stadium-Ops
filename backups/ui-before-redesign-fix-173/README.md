# UI backup: the live app before the redesign (fix-173)

This is the exact app that was live at https://asu-aramark.netlify.app on 2026-11-28
(BUILD_TAG `2026-11-27-fix-173`). `index.html`, `sw.js` and `manifest.json` were checked
byte-for-byte against the live site before saving.

Use it if the new UI is missing an option, or to roll the whole UI back.

## Restore the old UI on Netlify
1. Make a folder with the files from this backup:
   `index.html`, `sw.js`, `manifest.json`, `_headers`, `_redirects`, `icon-192.png`, `icon-512.png`
2. Copy the `ocr/` folder from the repo root into it (same files as live; not duplicated here).
3. Zip the folder contents and drop the zip on the Netlify deploy page.

## Find an old option
Open `index.html` and search for the button text (for example `Stand Transfer Record`).
The git tag `ui-backup-fix-173` also points at this point in history.

Note: the database is shared. Restoring the old UI does not undo any database changes.
