---
name: list-recipes
description: List all available recipes — both shipped (bundled with the plugin) and user-saved — showing id, name, tagline, layer count, and which one is currently active.
---

# List Recipes

## Steps

1. Resolve `$DATA_ROOT` (from `config.json`) and `$PLUGIN_ROOT` (the plugin directory).
2. Read `active_recipe` from `config.json` (may be null).
3. Enumerate recipes from both locations:
   - Shipped: `$PLUGIN_ROOT/recipes/*.json`
   - User: `$DATA_ROOT/recipes/*.json`
   If a user recipe shares an `id` with a shipped one, the user recipe wins (shadow it in the listing).
4. For each recipe, parse the JSON and print one block:

   ```
   <id>  [active]  (shipped|user)
     <name> — <tagline>
     <description>
     layers: <category>/<snippet>, <category>/<snippet>, …
   ```

   Mark `[active]` only on the recipe whose id matches `active_recipe`.

5. End with one line: `Apply with: /apply-recipe <id>` (or `swap-recipe <id>` to switch).

## Edge cases

- If no recipes exist anywhere, say so and point at `add-recipe` (when that skill exists).
- Malformed JSON: skip with a one-line warning naming the file.
