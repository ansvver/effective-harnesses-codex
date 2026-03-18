# Complete / Verify Feature

Use this flow when the user wants to finish a feature or confirm that it passes.

## Goal

Move a feature toward `completed` and `passes: true` without faking verification.

## Procedure

1. Read `.effective-harnesses/feature_list.json`.
2. Choose the target feature, preferring a currently `in_progress` feature.
3. Read its `verification` block.
4. Run the strongest available verification for that feature.
5. Update:
   - `verification.status`
   - `verification.summary`
   - `status`
   - `passes`
   - `notes`
   - `last_updated`
6. Update `.effective-harnesses/agent-progress.md` with the verification outcome and next recommended step.
7. Commit only if the repo is in a handoff-clean state.

## Interaction rules

Ask before completing a feature when any of these are unclear:

- whether the implementation is actually finished
- whether the current verification target is the right gate
- whether manual verification is acceptable
- whether a failing verification should block completion or allow `completed` with `passes: false`

Prefer short clarifications such as:

- `Should I treat this feature as blocked if the external service is unavailable?`
- `Is manual verification acceptable here, or do you want this to stay non-passing until automation exists?`
- `Should this feature be considered complete if the code is done but the verification still fails?`

## Decision rules

- Set `passes: true` only when verification succeeded.
- If implementation is done but verification failed, set:
  - `status: "completed"`
  - `passes: false`
  - `verification.status: "failed"`
- If implementation is done but only manual checks exist, keep `passes: false` unless the user explicitly accepts manual completion as sufficient and that policy is recorded.
- If the feature cannot proceed because of an external dependency, use `status: "blocked"` and explain the blocker in `notes`.
- If completion policy is ambiguous, ask instead of silently choosing one.
