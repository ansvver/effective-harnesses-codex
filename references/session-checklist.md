# Session Checklist

Use this checklist at the start of every `effective-harnesses` session.

## Required start sequence

1. Run `pwd`.
2. Read recent `git log`.
3. Read `.effective-harnesses/agent-progress.md`.
4. Read `.effective-harnesses/feature_list.json`.
5. Read `claude-progress.txt` if it exists.
6. Run `.effective-harnesses/init.sh` if relevant.
7. Verify baseline behavior before code edits.
8. Activate exactly one feature target.
9. If using run-to-pass, record:
   - feature id
   - pass gate
   - verification command or smoke check
   - blocker policy
10. Only then start substantial implementation.

## Required end sequence

1. Re-run relevant verification.
2. Update `.effective-harnesses/feature_list.json`.
3. Update `.effective-harnesses/agent-progress.md`.
4. Record blockers or deviations explicitly.
5. Leave the repo in a handoff-clean state.

## Integrity checks

- There is at most one active feature.
- `Current Focus` in `agent-progress.md` matches the active feature.
- `passes: true` is backed by real verification.
- If verification changed, the reason is recorded.
