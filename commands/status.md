# Harness Status

Use this flow when the user asks for the current project state under the harness.

## Procedure

1. Read `.effective-harnesses/feature_list.json`.
2. Read `.effective-harnesses/agent-progress.md`.
3. Read recent `git log`.
4. Summarize:
   - project name
   - total features
   - completed features
   - in-progress features
   - blocked features
   - pending features
   - strongest current verification signal
5. Identify the next recommended feature:
   - prefer an existing `in_progress` feature
   - otherwise choose the highest-priority incomplete feature
6. If multiple features appear active or the harness artifacts disagree on the active feature, call that out as a harness integrity issue.

## Reporting rules

- Distinguish `completed` from `passes: true`.
- Call out features that are implemented but not yet fully verified.
- Mention if the repo lacks strong automated tests and is relying on smoke or manual verification.
