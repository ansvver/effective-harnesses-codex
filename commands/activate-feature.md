# Activate Feature

Use this flow when a session needs to make one feature the explicit active target before substantial implementation.

## Goal

Ensure the harness has exactly one active session target and that both harness artifacts agree on that target before coding starts.

## Procedure

1. Read `.effective-harnesses/feature_list.json`.
2. Read `.effective-harnesses/agent-progress.md`.
3. Determine whether the user request maps to:
   - the current `in_progress` feature
   - an existing pending or blocked feature that should become active
   - a new feature that must be added first
4. If a different feature is currently active, downgrade it to a non-active state before activating the new one.
5. Update `.effective-harnesses/feature_list.json` so there is at most one `in_progress` feature.
6. Update `.effective-harnesses/agent-progress.md` so `Current Focus` matches the same feature.
7. Record the intended verification gate in `.effective-harnesses/agent-progress.md`.
8. Only then begin substantial implementation.

## Rules

- Do not silently treat a new user request as part of the current active feature unless the scope and verification target clearly match.
- Do not leave two features in an active state.
- Do not start code edits before the activation is recorded.
- If the correct feature mapping is unclear, ask before activating.

## Minimal activation record

After activation, the harness should clearly answer:

- Which feature id is active?
- Why is this the correct feature for the current request?
- What verification gate will be used?
- What conditions would block the feature?
