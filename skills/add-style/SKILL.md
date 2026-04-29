---
name: add-style
description: Add a new named style to the user's style-switcher library. Captures style name, short description, and the prompt body, then writes a markdown file with YAML frontmatter into the configured data root.
---

# Add Style

## Steps

1. Resolve `$DATA_ROOT` from `config.json`. If config is missing, run `onboard` first.
2. Ask:
   - **Name** (kebab-case, e.g. `concise`, `socratic`, `senior-eng-review`) — must be unique. Reject if `$DATA_ROOT/styles/<name>.md` already exists (offer `edit-style` instead).
   - **Description** (one line — used in `list-styles`).
   - **Body** — the actual prompt content. Either paste inline, dictate the intent and let Claude draft it, or point at an existing file to import.
3. Write to `$DATA_ROOT/styles/<name>.md`:

   ```markdown
   ---
   name: <name>
   description: <one-liner>
   created: <ISO-8601>
   ---

   <body>
   ```

4. Confirm by printing the path and offering to `apply-style <name>` immediately.

## What a style is (and isn't)

A style is a **subtle tonal preset**, not a mode or persona. Think register, sentence length, formality, hedging, vocabulary, whether to use emoji, paragraph vs. bullet preference, how confident to sound. Not "act like a pirate" or "always refuse politely" — those are personas/modes and belong somewhere else.

When the user lets Claude draft the body, keep it short (a few sentences max), declarative, second-person ("You..."), and focused on *how to phrase*, not *what to do*. Don't write meta-commentary about what the style does; just write the style.
