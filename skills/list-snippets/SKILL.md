---
name: list-snippets
description: List every snippet in the user's library, grouped by category, with the active snippet in each category marked. Reads from $DATA_ROOT/snippets and config.json.active_layers.
---

# List Snippets

## Steps

1. Resolve `$DATA_ROOT` from `config.json`. If missing, run `onboard` first.
2. Walk `$DATA_ROOT/snippets/`. Each subdirectory is a category. For each `.md` file inside, parse YAML frontmatter `name` and `description` (fall back to filename stem and "(no description)").
3. Read `active_layers` from `config.json` — a map of `category → snippet-name`.
4. Print grouped by category, sorted alphabetically. Mark the active snippet in each category with `[active]`. Categories with no active selection get a `(none active)` note.

Example output:

```
verbosity
  [active] ultra-curt — Default to one-line answers; expand only on request.
           detailed   — Walk through reasoning step by step.

initiative
  [active] free-spirit — Assume approval; never pause to ask permission.

tone (none active)
  warm — Light warmth, occasional enthusiasm.
  dry  — Flat, deadpan, no emotional padding.
```

If the snippets directory is empty, point the user at `add-snippet`.
