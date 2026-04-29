---
name: current-style
description: Show which style is currently applied — name, description, target path, and when it was applied. Reads active_style from config.json.
---

# Current Style

## Steps

1. Resolve `$DATA_ROOT` and read `config.json`.
2. If `active_style` is null, report "no style applied" and suggest `list-styles` + `apply-style`.
3. Otherwise print:
   - Name + description (from the style file's frontmatter)
   - Apply target type and resolved path
   - `applied_at` timestamp
   - First ~15 lines of the style body as a preview

Do not modify anything.
