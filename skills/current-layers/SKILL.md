---
name: current-layers
description: Show which snippet is currently active in each category and what the composed block in the target file looks like. Read-only.
---

# Current Layers

## Steps

1. Resolve `$DATA_ROOT` and read `config.json`.
2. If `active_layers` is empty, report "no layers applied" and suggest `apply-layers`.
3. Otherwise print:
   - `category — snippet — description` per active layer, alphabetical
   - The apply target path
   - `applied_at` timestamp
4. Optionally (if the user asks) extract the current `<!-- style-switcher:start -->` … `<!-- style-switcher:end -->` block from the target file and print it verbatim, so the user can see what Claude actually loads.

Do not modify anything.
