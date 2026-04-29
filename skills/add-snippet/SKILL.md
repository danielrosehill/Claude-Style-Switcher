---
name: add-snippet
description: Add a named style snippet to a category in the user's library. Creates the category directory if it doesn't exist. Snippets are short tonal fragments — register, terseness, hedging, formatting — meant to be layered together via apply-layers.
---

# Add Snippet

## Steps

1. Resolve `$DATA_ROOT` from `config.json`. If config is missing, run `onboard` first.
2. Ask:
   - **Category** (kebab-case dir name, e.g. `verbosity`, `initiative`, `tone`). List existing categories from `ls $DATA_ROOT/snippets/` and let the user pick or type a new one. Create the dir if new.
   - **Name** (kebab-case, e.g. `ultra-curt`, `free-spirit`) — must be unique within the category. Reject if `$DATA_ROOT/snippets/<category>/<name>.md` already exists (offer `edit-snippet`).
   - **Description** (one line — used in `list-snippets`).
   - **Body** — the actual snippet content. Either paste, dictate the intent, or import a file.
3. Write to `$DATA_ROOT/snippets/<category>/<name>.md`:

   ```markdown
   ---
   name: <name>
   category: <category>
   description: <one-liner>
   created: <ISO-8601>
   ---

   <body>
   ```

4. Confirm with the path, and ask whether to apply now (delegates to `apply-layers` to update `<category>` to this snippet).

## What a snippet is

A snippet is a **subtle composable fragment** — a few sentences that nudge tone in one specific dimension. Think:

- *verbosity / ultra-curt* — "Default to one-line answers."
- *initiative / free-spirit* — "Assume approval and keep moving."
- *hedging / no-hedge* — "State things flatly. Drop 'might', 'perhaps', 'I think'."
- *formatting / prose-preferred* — "Prefer short paragraphs over bulleted lists."

Not a persona, not a behavioral override, not a multi-paragraph manifesto. If it reads like a system prompt, it's too heavy.

## Drafting tone (when Claude writes the body)

Second-person ("You..."), present tense, declarative, focused on *how to phrase*. Two to four sentences max. No meta-commentary.
