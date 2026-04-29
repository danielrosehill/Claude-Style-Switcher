---
description: Strip the active style-switcher managed block from CLAUDE.md and return to the default config. Clears the active recipe and logs the action.
---

# /go-away

Restore the user's default CLAUDE.md by removing the style-switcher managed block. This is the sanctioned exit hatch from any active recipe.

## Steps

1. Resolve `$DATA_ROOT` from `config.json`. If config is missing, nothing to do — print a one-liner and stop.

2. Read `apply_target.type` from `config.json` and branch:

   **a) `claude-md-fragment` or `custom-path`** — strip the managed block.
   - Backup the target file to `$DATA_ROOT/backups/<basename>.<timestamp>.bak`.
   - If the target contains a `<!-- style-switcher:start -->` … `<!-- style-switcher:end -->` block, remove it (along with one trailing blank line if present). If no block exists, say so and stop — no file modification.

   **b) `repo-sandbox`** — reverse the hold + drop.
   - Backup the current `<cwd>/CLAUDE.md` (if it exists) to `$DATA_ROOT/backups/repo-claude-md.<timestamp>.bak`, then delete it.
   - If `~/.claude/CLAUDE_HELD.md` exists and `~/.claude/CLAUDE.md` does *not*, rename `CLAUDE_HELD.md` → `CLAUDE.md`. If `CLAUDE.md` already exists at the user level, do *not* overwrite it — leave the held file in place and warn the user that something restored their user CLAUDE.md while a sandbox was active. They should reconcile manually.
   - If neither file exists, the hold has already been reversed — print a one-liner and stop.

5. **Clear state.** In `config.json`:
   - Set `active_recipe` to null.
   - Set `active_layers` to `{}`.
   - Update `applied_at` to ISO-8601 now.

6. **Log.** Append one line to `$DATA_ROOT/state/history.jsonl`:
   ```json
   {"ts":"<iso>","action":"go-away","from":"<previous-recipe-id-or-null>","target":"<path>"}
   ```

7. **Confirm.** Print:
   ```
   👋 Default CLAUDE.md restored. Changes take effect on the next Claude Code session.
   ```

## Notes

- This command never edits content outside the managed block.
- The snippet library, the recipe library, and prior backups are untouched.
- Idempotent: running `/go-away` when nothing is active is a safe no-op.
