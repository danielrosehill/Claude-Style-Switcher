---
name: revert-style
description: Revert the most recent apply-style operation — restore the target file from the latest backup in $DATA_ROOT/backups/ and clear the active_style marker.
---

# Revert Style

## Steps

1. Resolve `$DATA_ROOT` and read `config.json`. Identify the current `apply_target.path`.
2. Find the most recent backup matching that target's basename in `$DATA_ROOT/backups/<basename>.*.bak`. Sort by mtime, pick newest.
3. If none exists, report and stop.
4. Show the backup timestamp and ask for confirmation before restoring.
5. Copy the backup over the target file (for `claude-md-fragment` mode this restores the whole CLAUDE.md, including any non-style edits made since — warn the user).
6. Set `active_style` to null in `config.json`.
7. Confirm what was restored.

## Note

For `output-style` mode, "reverting" means deleting the written `<name>.md` from `~/.claude/output-styles/` rather than restoring a prior file (since each style is its own file). Do that and tell the user to switch back to a different output style via `/output-style`.
