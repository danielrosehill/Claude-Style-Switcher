---
name: swap-recipe
description: Switch from the currently active recipe to a different one in a single step — clears the existing managed block, applies the new recipe (with banner pop-out and sound), and logs the swap as a single history entry.
---

# Swap Recipe

`swap-recipe` is the explicit verb for transitioning between recipes. It differs from `apply-recipe` only in intent and logging: the history entry records both the outgoing and incoming recipe, so substitution timelines stay readable.

## Steps

1. **Resolve roots** — `$DATA_ROOT` from `config.json`, `$PLUGIN_ROOT` from the plugin directory.

2. **Read current state.** Pull `active_recipe` (may be null) from `config.json`. If null and the user is calling `swap-recipe`, just delegate to `apply-recipe` — there's nothing to swap from.

3. **Resolve target recipe.** Argument is the new recipe `id`. Search `$DATA_ROOT/recipes/<id>.json` then `$PLUGIN_ROOT/recipes/<id>.json`. If the target id equals the current `active_recipe`, stop with `"<id>" is already active. Use /go-away to clear, or pick a different recipe.`

4. **Announce the swap.** Print:
   - `🎪 Swapping: <old-name> → <new-name>`
   - The new recipe's tagline and description.

5. **Pop-out banner + sound** for the *new* recipe — same non-blocking `mpv` + `paplay` invocation as `apply-recipe`. Skip gracefully if the recipe has none, or if the binaries are missing.

6. **Rewrite the target.** Same branching as `apply-recipe` step 6:
   - **Managed-block modes** (`claude-md-fragment`, `custom-path`): backup target, replace the `<!-- style-switcher:start -->` … `<!-- style-switcher:end -->` block with the new layers.
   - **`repo-sandbox`**: the user-level CLAUDE.md is *already held* from the previous recipe — do not re-rename. Backup the current `<cwd>/CLAUDE.md` to `$DATA_ROOT/backups/repo-claude-md.<timestamp>.bak`, then overwrite it with the new recipe's full file (header + per-layer sections).
   - Update `active_layers`, `active_recipe`, and `applied_at` in `config.json`.

7. **Log as a swap.** Append one line to `$DATA_ROOT/state/history.jsonl`:
   ```json
   {"ts":"<iso>","action":"swap-recipe","from":"<old-id>","to":"<new-id>","target":"<path>","layers":[…]}
   ```

8. **Print restore instructions** — same closing line as `apply-recipe`:

   ```
   TO RETURN TO YOUR DEFAULT CLAUDE.MD RUN /GO-AWAY
   ```

   Followed by the next-session reminder.

## Edge cases

- If the target recipe id doesn't exist, list available ids and stop without touching the target file.
- If the resolved snippet files are missing for the new recipe, abort *before* the backup/rewrite — leave the old recipe in place.
- A swap always implies a fresh banner pop-out, even if the user is moving between recipes that share layers.
