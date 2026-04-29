---
name: onboard
description: First-run setup for style-switcher. Creates the user-level data directory and writes config.json. Default apply target is a delimited fragment inside ~/.claude/CLAUDE.md, since the plugin layers multiple snippets together rather than swapping single output-styles.
---

# Onboard

Run on first use, or when the user wants to reconfigure.

## Data location

```bash
DATA_ROOT="${CLAUDE_USER_DATA:-${XDG_DATA_HOME:-$HOME/.local/share}/claude-plugins}/style-switcher"
mkdir -p "$DATA_ROOT/snippets" "$DATA_ROOT/recipes" "$DATA_ROOT/state" "$DATA_ROOT/backups"
```

Config goes in `$DATA_ROOT/config.json`. **Never** write config to `~/.claude/`.

## Steps

1. **Resolve `$DATA_ROOT`** as above. Create `snippets/`, `state/`, `backups/`.
2. **Detect existing config.** If `$DATA_ROOT/config.json` exists, ask whether to (a) edit a single field, (b) reset entirely (back up to `config.json.bak-<timestamp>` first), or (c) abort.
3. **Pick apply target.** Three modes — pick one and store it in config:
   - `claude-md-fragment` (default) — manages a `<!-- style-switcher:start -->` … `<!-- style-switcher:end -->` block inside `~/.claude/CLAUDE.md`. Layered on top of the user's normal config.
   - `custom-path` — user supplies an absolute path; same delimited-block protocol.
   - `repo-sandbox` — playground mode. **Renames** `~/.claude/CLAUDE.md` → `~/.claude/CLAUDE_HELD.md` to take it out of the harness, then writes the full recipe content as `<cwd>/CLAUDE.md` (not a managed block — the entire file is the persona). This is the safest way to test a persona in isolation without your serious config bleeding through. `/go-away` reverses both moves.

   Note on `repo-sandbox`: while a recipe is active in this mode, **every** Claude Code session on the machine sees the held state (no user-level CLAUDE.md is loaded). If the user mostly runs one Claude Code session at a time this is fine — if they run several concurrently, warn them.
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
  // or, for repo-sandbox mode:
  // "apply_target": { "type": "repo-sandbox" },
  "active_layers": {},
  "active_recipe": null,
  "applied_at": null,
  "configured_at": "2026-04-29T00:00:00Z"
}
```

`active_layers` maps `category → snippet-name`. `active_recipe` holds the id of the currently-applied recipe (or null when layers were composed manually via `apply-layers`). Both are empty/null until the user applies something.

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
