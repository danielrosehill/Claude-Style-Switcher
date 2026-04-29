# Claude Style Switcher — Claude Code Plugin

A modular, layerable system for shaping Claude Code's tone and voice.

Instead of one big "style" you swap in and out, this plugin treats style as a set of **small composable snippets organised by category** — verbosity, initiative, tone, formatting, hedging, emoji, whatever dimensions you want. Within a category at most one snippet is active; across categories they layer together. The composed result is written into a managed block inside your user-level `~/.claude/CLAUDE.md`.

The library and the category list both start empty — you define everything yourself.

## Why snippets, not styles

A snippet is one or two sentences nudging Claude in a single dimension:

- *verbosity / ultra-curt* — "Default to one-line answers."
- *initiative / free-spirit* — "Assume approval; don't pause to confirm."
- *hedging / no-hedge* — "State things flatly. Drop 'might', 'I think'."

You mix the ones you want, switch one out without disturbing the others, and the rest of your CLAUDE.md stays untouched.

## Skills

**Setup**
- `onboard` — pick the apply target (default: `~/.claude/CLAUDE.md`), create the data directory

**Library**
- `add-snippet` — create a new snippet in a category (creates the category if new)
- `edit-snippet` — modify an existing snippet
- `delete-snippet` — remove one
- `list-snippets` — list everything grouped by category, with active ones marked

**Composition**
- `apply-layers` — pick at most one snippet per category, compose them into a managed block in the target file
- `current-layers` — show what's currently active
- `clear-layers` — strip the managed block; library is untouched

## Data location

```
${CLAUDE_USER_DATA:-${XDG_DATA_HOME:-$HOME/.local/share}/claude-plugins}/style-switcher/
├── config.json
├── snippets/
│   ├── <category>/<snippet>.md
│   └── ...
├── state/
└── backups/         # pre-apply snapshots of the target file
```

Override the data root by setting `$CLAUDE_USER_DATA` before launching Claude Code.

## Apply target

Default is `claude-md-fragment` writing to `~/.claude/CLAUDE.md` — a delimited managed block:

```markdown
<!-- style-switcher:start -->
## Style: verbosity — ultra-curt
…body…

## Style: initiative — free-spirit
…body…
<!-- style-switcher:end -->
```

`apply-layers` rewrites only what's between the markers; everything else in your CLAUDE.md is left alone. `clear-layers` removes the block entirely.

You can point the target at any other file via `onboard` (`custom-path` mode) — same delimited-block protocol.

## Composition rule

Within a category, at most one snippet is active. Across categories, they all layer.

## License

MIT — see `LICENSE`.
