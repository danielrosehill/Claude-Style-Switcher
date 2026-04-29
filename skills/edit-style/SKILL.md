---
name: edit-style
description: Edit an existing style in the user's library — modify the body or description in place. If the style is currently active, offer to re-apply afterwards so the change takes effect.
---

# Edit Style

## Steps

1. Resolve `$DATA_ROOT`. If style name not supplied, list and ask.
2. Open `$DATA_ROOT/styles/<name>.md`. Show the current body and ask the user what to change — or accept a full replacement body.
3. Write back, preserving frontmatter `name` and `created` fields. Update `description` if the user changed it. Add/refresh a `modified:` ISO-8601 field.
4. If `config.json.active_style == <name>`, ask whether to re-apply now. If yes, delegate to `apply-style <name>`.
