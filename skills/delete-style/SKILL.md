---
name: delete-style
description: Remove a named style from the user's library. Confirms before deleting; refuses to delete the currently active style without an explicit force flag.
---

# Delete Style

## Steps

1. Resolve `$DATA_ROOT`. Validate `$DATA_ROOT/styles/<name>.md` exists.
2. If `config.json.active_style == <name>`, refuse unless the user confirms a force-delete (and offer to `revert-style` first).
3. Confirm by showing the style's description and first few lines of body.
4. Delete the file. Do not touch backups in `$DATA_ROOT/backups/`.
5. If it was the active style and the user forced through, set `active_style` to null.
