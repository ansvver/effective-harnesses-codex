# Add Feature

Use this flow when the user wants to add tracked work to `.effective-harnesses/feature_list.json`.

## Goal

Add a single well-scoped feature entry that can be worked on incrementally in later sessions.

## Procedure

1. Confirm the project is already harnessed.
2. Read `.effective-harnesses/feature_list.json`.
3. Gather or infer:
   - category
   - short description
   - implementation steps
   - priority
   - verification strategy
4. Generate the next sequential feature ID.
5. Append the new feature without modifying unrelated entries.
6. If this new feature is the current session target, immediately follow `commands/activate-feature.md` before substantial implementation.

## Interaction rules

If the new feature request is too vague to implement safely, ask before creating it.

Ask when any of these are unclear:

- what user-visible or engineering outcome the feature should produce
- what is in scope versus out of scope
- what should count as "done"
- what verification target should be attached to the feature

Prefer a short clarification such as:

- `What should count as passed for this feature: a test command, a build, or a smoke check?`
- `Should this feature cover only X, or both X and Y?`
- `What is the concrete output you expect when this feature is done?`

## Feature quality rules

- Prefer one user-visible or engineering-coherent outcome per feature.
- Keep `steps` concrete and bounded.
- Default `status` to `pending`.
- Default `passes` to `false`.
- Set `verification.strategy` based on the strongest known verification path.
- If no command exists yet, leave `verification.command` null and explain the plan in `verification.summary`.
- If the pass condition is unclear, ask before finalizing the feature entry instead of inventing a weak verification target.
- Do not mark a newly added feature `in_progress` unless the session is explicitly activating it right now.

## Categories

- `functional`
- `bugfix`
- `refactor`
- `docs`
- `ops`
