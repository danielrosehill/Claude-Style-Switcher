# Claude Style Switcher — Claude Code Plugin

Manage and switch between named output **styles** for Claude Code — subtle tone, register, and voice presets you define yourself. Not modes, not personas: small adjustments to how Claude phrases things (formality, terseness, hedging, vocabulary, emoji-or-not) without changing what it can do.

Styles live in a user-level data directory and are applied to `~/.claude/output-styles/` (or a CLAUDE.md fragment, or any custom path) on demand. The library starts empty — you write every style.

## Skills

**Setup**
- `onboard` — first-run setup: pick where the active style should be written, create the data directory

**Library**
- `add-style` — create a new named style
- `edit-style` — modify an existing one
- `delete-style` — remove one
- `list-styles` — show every style with the active one marked

**Switching**
- `apply-style <name>` — write the chosen style to the configured target and mark it active
- `current-style` — show what's currently applied
- `revert-style` — restore from the most recent backup

## Data location

```
${CLAUDE_USER_DATA:-${XDG_DATA_HOME:-$HOME/.local/share}/claude-plugins}/style-switcher/
├── config.json     # apply_target, active_style
├── styles/         # one .md file per named style
├── state/          # reserved
└── backups/        # pre-apply snapshots of the target file
```

Override the data root by setting `$CLAUDE_USER_DATA` before launching Claude Code.

## Apply targets

Picked during `onboard`:

| Type | Where the active style lands | How it takes effect |
|------|------------------------------|---------------------|
| `output-style` | `~/.claude/output-styles/<name>.md` | `/output-style <name>` |
| `claude-md-fragment` | A delimited block inside `~/.claude/CLAUDE.md` | Next Claude Code session |
| `custom-path` | Any file you point at | Whatever consumes that file |

## License

MIT — see `LICENSE`.
