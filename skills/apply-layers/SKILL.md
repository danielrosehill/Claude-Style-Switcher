---
name: apply-layers
description: Compose the active snippet from each chosen category into a single delimited block and write it into the configured target file (default ~/.claude/CLAUDE.md). Within a category at most one snippet is active; across categories they layer.
---

# Apply Layers

## Steps

1. Resolve `$DATA_ROOT` from `config.json`. If missing, run `onboard`.
2. **Determine selections.** Two modes:
   - **Interactive** (no args): walk every category in `$DATA_ROOT/snippets/`. For each, show the current active snippet (if any) and the available options, and ask the user to (a) keep current, (b) switch to a different snippet, or (c) clear this category. Skip categories the user has no opinion on.
   - **Direct**: user passes `<category>:<snippet>` pairs. Validate each. Categories not mentioned keep their existing active snippet.
3. **Update `active_layers`** in `config.json` with the new mapping. Drop keys whose value is null/cleared.
4. **Backup target.** Copy current target file (e.g. `~/.claude/CLAUDE.md`) to `$DATA_ROOT/backups/<basename>.<timestamp>.bak` before touching it.
5. **Build the block.** For each entry in `active_layers`, in alphabetical category order, read the snippet body (frontmatter stripped) and emit:

   ```markdown
   <!-- style-switcher:start -->
   <!-- Managed by style-switcher plugin. Edit via add-snippet/edit-snippet, not by hand. -->

   ## Style: <category> — <snippet>

   <body>

   ## Style: <category> — <snippet>

   <body>
   <!-- style-switcher:end -->
   ```

6. **Write.** If the target already contains a `<!-- style-switcher:start -->` … `<!-- style-switcher:end -->` block, replace it in place. Otherwise append the block at the end of the file (preceded by a blank line).
7. **Update `applied_at`** in `config.json` to ISO-8601 now. Set `active_recipe` to null (manual layer composition is not a recipe).
8. **Log.** Append one JSON line to `$DATA_ROOT/state/history.jsonl` (create the directory if needed):
   ```json
   {"ts":"<iso>","action":"apply-layers","target":"<path>","layers":[{"category":"...","snippet":"..."}]}
   ```
9. **Confirm.** Print the resolved target path, the layered selection (`category — snippet` per line), and remind the user that CLAUDE.md changes take effect on the next Claude Code session. Close with `TO RETURN TO YOUR DEFAULT CLAUDE.MD RUN /GO-AWAY`.

## Edge cases

- If `active_layers` is empty after the update, write **no** managed block — strip any existing one. The user's CLAUDE.md should be unmodified beyond block removal.
- If a referenced snippet file no longer exists, drop that entry with a warning.
- Never touch content outside the delimited block.
