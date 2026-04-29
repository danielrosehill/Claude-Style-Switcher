---
name: onboard
description: First-run setup for style-switcher. Creates the user-level data directory and writes config.json. Default apply target is a delimited fragment inside ~/.claude/CLAUDE.md, since the plugin layers multiple snippets together rather than swapping single output-styles.
---

# Onboard

Run on first use, or when the user wants to reconfigure.

## Data location

```bash
DATA_ROOT="${CLAUDE_USER_DATA:-${XDG_DATA_HOME:-$HOME/.local/share}/claude-plugins}/style-switcher"
mkdir -p "$DATA_ROOT/snippets" "$DATA_ROOT/state" "$DATA_ROOT/backups"
```

Config goes in `$DATA_ROOT/config.json`. **Never** write config to `~/.claude/`.

## Steps

1. **Resolve `$DATA_ROOT`** as above. Create `snippets/`, `state/`, `backups/`.
2. **Detect existing config.** If `$DATA_ROOT/config.json` exists, ask whether to (a) edit a single field, (b) reset entirely (back up to `config.json.bak-<timestamp>` first), or (c) abort.
3. **Pick apply target.** Default is `claude-md-fragment` writing to `~/.claude/CLAUDE.md`. Offer alternatives only if asked:
   - `claude-md-fragment` (default) — manages a `<!-- style-switcher:start -->` … `<!-- style-switcher:end -->` block inside the target file
   - `custom-path` — user supplies an absolute path; same delimited-block protocol
4. **Write config.** See shape below.
5. **Confirm.** Print `$DATA_ROOT`, the apply target path, and remind the user the snippet library is empty — point them at `add-snippet`.

The plugin ships with **no built-in snippets and no fixed category list**. The user defines both as they go.

## config.json shape

```json
{
  "data_root": "/home/<user>/.local/share/claude-plugins/style-switcher",
  "apply_target": {
    "type": "claude-md-fragment",
    "path": "/home/<user>/.claude/CLAUDE.md"
  },
  "active_layers": {},
  "configured_at": "2026-04-29T00:00:00Z"
}
```

`active_layers` maps `category → snippet-name`. Empty until the user runs `apply-layers`.

## Layout

```
$DATA_ROOT/snippets/
├── <category-1>/
│   ├── <snippet-a>.md
│   └── <snippet-b>.md
├── <category-2>/
│   └── ...
```

A "category" is just a subdirectory. Suggested dimensions: `verbosity`, `initiative`, `tone`, `formatting`, `hedging`, `emoji`. The user defines whichever they want.

## Composition rule

Within a single category, **at most one** snippet can be active. Across categories, snippets compose — they all get written into the delimited block in target file order.
