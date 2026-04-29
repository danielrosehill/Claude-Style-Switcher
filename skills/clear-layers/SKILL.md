---
name: clear-layers
description: Strip the style-switcher managed block from the target file and clear active_layers in config.json. Equivalent to "no styles applied" without deleting any snippets.
---

# Clear Layers

## Steps

1. Resolve `$DATA_ROOT` and read `config.json`. Identify `apply_target.path`.
2. Backup the current target file to `$DATA_ROOT/backups/<basename>.<timestamp>.bak`.
3. Remove the entire `<!-- style-switcher:start -->` … `<!-- style-switcher:end -->` block (and the blank line preceding it, if present) from the target file. Leave everything else untouched.
4. Set `active_layers: {}` and `active_recipe: null` in `config.json`. Update `applied_at` to ISO-8601 now.
5. Append one JSON line to `$DATA_ROOT/state/history.jsonl`:
   ```json
   {"ts":"<iso>","action":"clear-layers","target":"<path>"}
   ```
6. Confirm — print the target path and "no layers active".

Snippets in the library are not deleted. Use `delete-snippet` for that.
