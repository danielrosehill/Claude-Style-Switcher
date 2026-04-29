---
name: apply-recipe
description: Activate a named recipe — a pre-bundled set of style snippets shipped with the plugin (or saved by the user). Plays the recipe's banner image as a fullscreen pop-out animation with sound, writes the bundled snippets into the managed CLAUDE.md block, logs the substitution, and reminds the user how to revert.
---

# Apply Recipe

A **recipe** is a persisted, named bundle of style snippets — id, banner image, sound effect, and one or more (category, snippet) layer entries. Shipped recipes live in `${CLAUDE_PLUGIN_ROOT}/recipes/`. User-saved recipes live in `$DATA_ROOT/recipes/`.

## Steps

1. **Resolve roots.**
   - `$DATA_ROOT` from `config.json` (run `onboard` if missing).
   - `$PLUGIN_ROOT` = the directory containing this plugin's `.claude-plugin/plugin.json` (i.e. the repo root).

2. **Locate the recipe.** Argument is the recipe `id`. Search in order:
   - `$DATA_ROOT/recipes/<id>.json` (user)
   - `$PLUGIN_ROOT/recipes/<id>.json` (shipped)
   If not found, list available ids from both locations and stop.

3. **Resolve referenced snippets.** For each layer entry `{category, snippet}`:
   - Prefer `$DATA_ROOT/snippets/<category>/<snippet>.md` if it exists (user override).
   - Otherwise fall back to `$PLUGIN_ROOT/snippets/<category>/<snippet>.md`.
   - If neither exists, abort with a clear error naming the missing snippet.

4. **Announce.** Print, in this order:
   - `🎪 Activating recipe: <name> — <tagline>`
   - The recipe description (one paragraph).

5. **Pop-out banner.** If `banner` is set and the file exists, in a non-blocking subprocess:
   ```bash
   paplay "$PLUGIN_ROOT/<sound>" >/dev/null 2>&1 &
   mpv --fullscreen --no-osc --really-quiet \
       --image-display-duration=3 \
       --vf="zoompan=z='min(1+0.02*on,1.6)':d=1:s=1920x1080" \
       "$PLUGIN_ROOT/<banner>" >/dev/null 2>&1 &
   ```
   If `banner` or `sound` is null, skip that part. If `mpv` or `paplay` is missing, print a one-line warning and continue — the swap must still happen.

6. **Apply layers — branch on `apply_target.type`:**

   **a) `claude-md-fragment` or `custom-path` (managed-block modes)**
   - Backup target file to `$DATA_ROOT/backups/<basename>.<timestamp>.bak`.
   - Replace (or append) the `<!-- style-switcher:start -->` … `<!-- style-switcher:end -->` block with one `## Style: <category> — <snippet>` section per layer, body inlined from the resolved snippet file (frontmatter stripped).

   **b) `repo-sandbox` (hold + drop)**
   - **Hold the user file.** If `~/.claude/CLAUDE.md` exists and `~/.claude/CLAUDE_HELD.md` does *not*, rename `CLAUDE.md` → `CLAUDE_HELD.md`. If `CLAUDE_HELD.md` already exists, the user already has a hold in place — proceed without re-holding (do not clobber). If `CLAUDE.md` is missing entirely, just proceed.
   - **Backup any existing repo CLAUDE.md.** If `<cwd>/CLAUDE.md` exists, copy it to `$DATA_ROOT/backups/repo-claude-md.<timestamp>.bak`.
   - **Write the persona file.** Replace `<cwd>/CLAUDE.md` entirely with: a one-line header noting it's managed by style-switcher, the recipe name + tagline + description, then one `## Style: <category> — <snippet>` section per layer (body inlined from the resolved snippet file, frontmatter stripped). This is the *whole file*, not a managed block.
   - Record `apply_target.repo_path = <cwd>/CLAUDE.md` and `held_user_md = ~/.claude/CLAUDE_HELD.md` in `config.json` so `/go-away` knows what to reverse.

   In both modes: update `active_layers`, `active_recipe`, and `applied_at` in `config.json`.

7. **Log the substitution.** Append one JSON line to `$DATA_ROOT/state/history.jsonl`:
   ```json
   {"ts":"<iso8601>","action":"apply-recipe","recipe":"<id>","target":"<path>","layers":[{"category":"...","snippet":"..."}]}
   ```
   Create `state/` if needed.

8. **Print restore instructions.** Always close with this line, verbatim and prominent:

   ```
   TO RETURN TO YOUR DEFAULT CLAUDE.MD RUN /GO-AWAY
   ```

   Then a one-line reminder that CLAUDE.md changes take effect on the next Claude Code session.

## Edge cases

- A recipe with an empty `layers` array is a no-op for the managed block (and should strip any existing one), but the banner + sound + restore message still play.
- Never touch content outside the delimited block.
- If the user already has a recipe active (`config.json` has `active_recipe`), proceed — the new recipe replaces it. (`swap-recipe` is the explicit verb for this; `apply-recipe` is forgiving.)
