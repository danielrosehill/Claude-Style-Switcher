---
name: apply-style
description: Apply a named style — write the style body to the configured Claude target (output-style file, CLAUDE.md fragment, or custom path) and update the active-style marker. Backs up the prior target content first.
---

# Apply Style

## Steps

1. Resolve `$DATA_ROOT` from `config.json`. If missing, run `onboard` first.
2. Read the requested style name (from the user's invocation). If absent, list available styles and ask.
3. Validate `$DATA_ROOT/styles/<name>.md` exists. If not, list candidates and stop.
4. Load `apply_target` from `config.json`:
   - **output-style**: target file is `<apply_target.path>/<name>.md`. Write the style body (frontmatter stripped, or rewritten to Claude Code's output-style frontmatter shape: `name`, `description`). Tell the user to activate with `/output-style <name>`.
   - **claude-md-fragment**: target file is `<apply_target.path>` (typically `~/.claude/CLAUDE.md`). Replace any existing block delimited by `<!-- style-switcher:start -->` and `<!-- style-switcher:end -->` with the new style body wrapped in those markers. If no markers exist yet, append the wrapped block at the end of the file.
   - **custom-path**: overwrite `<apply_target.path>` with the style body.
5. **Backup first.** Before writing, copy the current target file (if it exists) to `$DATA_ROOT/backups/<basename>.<timestamp>.bak`. This is what `revert-style` restores from.
6. Update `config.json`: set `active_style` to `<name>`, `applied_at` to ISO-8601 now.
7. Confirm with the resolved target path and a one-line reminder of how to activate (output-style mode) or that it's already in effect (CLAUDE.md mode — takes effect on next Claude Code session).

## Output-style frontmatter rewrite

When writing to `~/.claude/output-styles/`, the file must start with:

```markdown
---
name: <Display Name>
description: <one-liner from the style file>
---
```

Strip the `created:` field; the rest of the body follows verbatim.
