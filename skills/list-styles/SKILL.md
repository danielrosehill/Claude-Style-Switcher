---
name: list-styles
description: List every named style in the user's style-switcher library, marking which one is currently active. Reads from the data root configured during onboarding.
---

# List Styles

## Steps

1. Resolve `$DATA_ROOT` from `$DATA_ROOT/config.json` (or recompute via the env-var fallback if the user hasn't run `onboard` yet — in that case suggest running `onboard` first).
2. List every `*.md` file in `$DATA_ROOT/styles/`. For each, parse YAML frontmatter `name` and `description` if present; otherwise use the filename stem.
3. Read `active_style` from `config.json` and mark that entry with `[active]`.
4. Print as a compact table: `name — description`, sorted alphabetically.

If `$DATA_ROOT/styles/` is empty, point the user at `add-style` — the library starts empty and the user defines every style themselves.
