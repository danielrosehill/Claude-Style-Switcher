---
name: delete-snippet
description: Remove a snippet from the library. Refuses to delete the currently active snippet in its category without explicit confirmation. Cleans up empty category directories.
---

# Delete Snippet

## Steps

1. Resolve `$DATA_ROOT`. Validate `$DATA_ROOT/snippets/<category>/<name>.md` exists.
2. If `config.json.active_layers[<category>] == <name>`, refuse unless the user confirms a force-delete. Offer to clear that category from active_layers first (and re-run `apply-layers` to rebuild the block without it).
3. Confirm by showing description and first few lines of body.
4. Delete the file.
5. If `$DATA_ROOT/snippets/<category>/` is now empty, remove the directory.
6. If active and force-deleted, drop the category key from `active_layers`.
