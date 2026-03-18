# Harness Notes

This project uses the `effective-harnesses` workflow for long-running Codex sessions.

Read `references/session-checklist.md` from the skill before starting any substantial session work.

## Session Start

1. Run `pwd`.
2. Read `.effective-harnesses/agent-progress.md`.
3. Read `.effective-harnesses/feature_list.json`.
4. Read recent `git log`.
5. Run `.effective-harnesses/init.sh` if present.
6. Activate exactly one feature target in the harness artifacts.
7. Verify baseline behavior before implementing a new feature.

## Working Rules

- Work on one feature at a time.
- Keep exactly one active feature target recorded in both harness artifacts.
- Do not mark a feature as passing without verification.
- Leave handoff notes in `.effective-harnesses/agent-progress.md`.
- Keep `.effective-harnesses/feature_list.json` as the durable feature registry.
