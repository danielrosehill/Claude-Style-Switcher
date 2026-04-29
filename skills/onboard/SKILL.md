---
name: onboard
description: First-run setup for style-switcher. Creates the user-level data directory, asks where the active style should be written (output-style file, CLAUDE.md fragment, or custom path), and writes config.json. The styles library starts empty — the user populates it via add-style.
---

# Onboard

Run on first use, or when the user wants to reconfigure the plugin.

## Data location

```bash
DATA_ROOT="${CLAUDE_USER_DATA:-${XDG_DATA_HOME:-$HOME/.local/share}/claude-plugins}/style-switcher"
mkdir -p "$DATA_ROOT/styles" "$DATA_ROOT/state" "$DATA_ROOT/backups"
```

Config goes in `$DATA_ROOT/config.json`. **Never** write config to `~/.claude/`.

## Steps

1. **Resolve `$DATA_ROOT`** as above. Create `styles/`, `state/`, and `backups/` subdirs.
2. **Detect existing config.** If `$DATA_ROOT/config.json` exists, ask whether to (a) edit a single field, (b) reset entirely (back up to `config.json.bak-<timestamp>` first), or (c) abort.
3. **Pick apply target.** Ask which Claude target the active style should be written to:
   - `output-style` (default) — writes to `~/.claude/output-styles/<style-name>.md`, then user activates with `/output-style <name>`
   - `claude-md-fragment` — appends/replaces a delimited block in `~/.claude/CLAUDE.md`
   - `custom-path` — user supplies an absolute path; plugin overwrites that file when applying
4. **Write config.** See shape below.
5. **Confirm.** Print resolved `$DATA_ROOT`, the apply target, and remind the user the styles library is empty — point them at `add-style` to create their first one.

The plugin ships with **no built-in styles**. The user defines all styles themselves via `add-style`.

## config.json shape

```json
{
  "data_root": "/home/<user>/.local/share/claude-plugins/style-switcher",
  "apply_target": {
    "type": "output-style",
    "path": "/home/<user>/.claude/output-styles"
  },
  "active_style": null,
  "configured_at": "2026-04-29T00:00:00Z"
}
```

For `claude-md-fragment`, `path` is the CLAUDE.md file; the apply skill manages a `<!-- style-switcher:start --> ... <!-- style-switcher:end -->` block inside it.

For `custom-path`, `path` is the exact file the apply skill overwrites.

## After onboarding

Point the user at:
- `add-style` — create your first style
- `list-styles` — see what's in the library
- `apply-style <name>` — switch to one
