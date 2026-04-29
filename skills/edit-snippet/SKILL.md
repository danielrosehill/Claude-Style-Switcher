---
name: edit-snippet
description: Edit an existing snippet in place — change body or description. If the snippet is currently active in its category, offer to re-run apply-layers so the change takes effect.
---

# Edit Snippet

## Steps

1. Resolve `$DATA_ROOT`. If category and/or name not supplied, list and ask.
2. Open `$DATA_ROOT/snippets/<category>/<name>.md`. Show the current body and ask what to change — or accept a full replacement body.
3. Write back, preserving frontmatter `name`, `category`, and `created`. Update `description` if changed. Add/refresh a `modified:` ISO-8601 field.
4. If `config.json.active_layers[<category>] == <name>`, ask whether to re-apply now; if yes, delegate to `apply-layers` (no selection changes, just rebuild the block).
