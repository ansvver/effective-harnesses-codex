---
name: effective-harnesses
description: Codex harness for long-running work across multiple sessions. Use for bootstrap/adoption of a durable agent workflow with feature tracking, session recovery, startup verification, and one-feature-at-a-time progress in both existing repos and new projects.
---

# Effective Harnesses

Use this skill when the user wants to:

- bootstrap a long-running agent harness in the current project
- adopt a repo into a durable multi-session workflow
- add or manage tracked features for iterative implementation
- recover project state across sessions using durable artifacts
- keep executing a single feature until automated verification passes or a real blocker is reached

This skill implements the durable ideas from Anthropic's "Effective harnesses for long-running agents" while adapting them to Codex and to mixed project types.

## Core rules

- Work on one feature at a time.
- Keep durable state in JSON so later sessions can recover quickly.
- Prefer discovering project commands from the repo before asking the user.
- Never treat "missing harness files" as proof the repo is new.
- Only mark a feature as passing after real verification.
- Leave the repo in a handoff-clean state before ending a session.
- If the user request is ambiguous in a way that changes implementation or verification, pause and ask concise clarifying questions before executing.
- Do not enter run-to-pass mode until you have confirmed that the user actually wants continuous autonomous iteration.

## Strict execution requirements

Treat the workflow in this skill as mandatory, not advisory.

- Do not start implementation until the session bootstrap steps have been completed.
- Do not work on a new request by "mentally mapping" it to an existing feature without first recording that decision in the harness artifacts.
- Do not switch active features mid-session without updating `.effective-harnesses/feature_list.json` and `.effective-harnesses/agent-progress.md` first.
- Do not treat a new user request as part of the current active feature unless the intent, verification target, and scope clearly match.
- Do not mark `status: "completed"` together with `passes: true` unless the verification command or smoke check has actually been run in the current session or the current session has directly inspected fresh persisted verification output.
- Do not claim run-to-pass behavior unless the feature, gate, and blocker conditions have been explicitly confirmed or concretely inferred and then recorded in the harness notes.
- If the repo state prevents strict adherence to the loop, state the deviation explicitly in `.effective-harnesses/agent-progress.md` before proceeding.

## Artifacts

Canonical harness artifacts:

- `.effective-harnesses/feature_list.json`
- `.effective-harnesses/agent-progress.md`
- `.effective-harnesses/init.sh` when the repo has a meaningful local startup flow
- `.effective-harnesses/HARNESS.md` for concise repo-local usage notes

Compatibility rule:

- If `claude-progress.txt` already exists, read it as historical context during adoption, but use `.effective-harnesses/agent-progress.md` as the canonical artifact going forward.
- Keep harness artifacts in a hidden repo-local directory, `.effective-harnesses/`, to avoid root-level filename collisions.
- Use safe automatic cleanup for runtime state: clear stale pid markers before startup, but do not automatically stop live services unless the user explicitly asks.

## Bootstrapping and adoption

Always detect which path applies before making changes.

### Path A: Existing repo adoption

Treat the repo as existing if any of these are true:

- `.git/` exists
- common manifests already exist, such as `package.json`, `pyproject.toml`, `requirements.txt`, `Cargo.toml`, `go.mod`
- source trees already exist, such as `src/`, `app/`, `backend/`, `frontend/`

In this path:

- do not run `git init`
- do not assume the repo needs a fresh initial commit
- inspect project files to infer startup and verification commands
- create harness artifacts around the existing codebase

### Path B: New project bootstrap

Treat the repo as new only if it is effectively empty and lacks git history and common project manifests.

In this path:

- create the harness artifacts
- create `init.sh` if the user or repo context provides a meaningful startup command
- initialize git only if the repo is not already a git repo

## Discovery heuristics

Before asking the user for commands, inspect the repo.

Look for startup commands in:

- `package.json` scripts
- `pyproject.toml`
- `requirements.txt`
- `Makefile`
- `docker-compose*.yml`
- `*.sh` scripts at the repo root
- repo guidance files such as `CLAUDE.md`, `AGENTS.md`, `README.md`, `docs/DEVELOPMENT.md`

Look for verification commands in:

- `package.json` test/build/lint scripts
- `pytest.ini`, `tox.ini`, `noxfile.py`
- `pyproject.toml`
- `Makefile`
- existing test directories or smoke-test scripts

Only ask the user if startup or verification is still ambiguous after discovery.

## Interaction rules

Use lightweight interaction when the user intent is not decision-complete.

Ask before execution when any of these are true:

- the user described a desired outcome but not the concrete feature scope
- multiple plausible interpretations would change code, tests, or data flow
- the user asked to "keep going" or "finish it" but it is unclear whether they want a normal one-pass implementation or run-to-pass
- the verification target is missing, weak, or could be interpreted in multiple ways

When asking:

- keep questions short and concrete
- prefer asking for the minimum information needed to unblock execution
- present the inferred default when possible
- once the user answers, record the decision in `.effective-harnesses/feature_list.json` or `.effective-harnesses/agent-progress.md` if it affects future sessions

When the user request is clear enough to proceed without questions:

- still record the interpreted feature choice before substantial implementation
- still record the inferred verification gate before entering run-to-pass behavior

## Session operating loop

Before executing the loop, read `references/session-checklist.md` and follow it as a hard checklist.

For each coding session in a harnessed project:

1. Run `pwd`.
2. Read recent `git log`.
3. Read `.effective-harnesses/agent-progress.md` if present, and also `claude-progress.txt` if present.
4. Read `.effective-harnesses/feature_list.json`.
5. Choose the highest-priority incomplete feature, unless one is already `in_progress`.
6. Run `.effective-harnesses/init.sh` if present and relevant.
7. Verify baseline functionality before touching code.
8. Implement exactly one feature, or one bounded slice of a blocked feature.
9. Re-run relevant verification.
10. Update `.effective-harnesses/feature_list.json` and `.effective-harnesses/agent-progress.md`.
11. Commit only when the repo is in a handoff-clean state.

Interpret the loop strictly:

- Step 5 is not complete until there is exactly one active target for the session:
  - either an existing `in_progress` feature
  - or a newly added/updated feature entry that explicitly captures the current request
- If the user request introduces a new feature while another one is active, resolve that conflict in the harness files before coding. Do not silently proceed.
- Step 7 must happen before code edits. If baseline verification is impossible, record why in `.effective-harnesses/agent-progress.md` and treat that as an explicit constraint on later verification.
- Step 10 is required even if the session ends blocked or partially complete.

## Feature activation protocol

Before substantial implementation, make the active feature explicit.

1. Read `.effective-harnesses/feature_list.json`.
2. Determine whether the user request maps to:
   - the current `in_progress` feature
   - an existing pending feature that should become active
   - a new feature that must be added
3. Update `.effective-harnesses/feature_list.json` so there is a single active session target.
4. Update `.effective-harnesses/agent-progress.md` to reflect the same active target and the intended verification gate.
5. Only then start substantial code changes.

If the active feature changes during the session, repeat this protocol before continuing.

## Verification policy

Do not assume every project has a strong automated test suite.

Use the strongest available verification in this order:

1. Automated tests
2. Build or typecheck validation
3. Startup plus HTTP, CLI, or API smoke checks
4. Manual verification

Record verification explicitly in `.effective-harnesses/feature_list.json`.

A feature may be marked:

- `status: "completed"` if the implementation work is done
- `passes: true` only if verification actually passed

If verification is manual or incomplete, keep `passes: false` and note why.

## Run-to-pass mode

Use run-to-pass mode when the user wants Codex to keep working on the current feature until it passes verification.

This mode is only valid when:

- one feature is clearly active
- the feature has a concrete verification target
- the strongest available verification can actually be re-run during the session

Before starting run-to-pass, explicitly confirm or infer these points:

- which feature is the target
- whether the user really wants continuous autonomous iteration instead of a normal implementation pass
- what counts as a passing result
- what verification command, build check, smoke check, or endpoint should be treated as the gate
- what blockers should stop the loop instead of triggering more retries

If any of those remain unclear after repo inspection, ask the user before starting the loop.

Before the first implementation step in run-to-pass mode, record in `.effective-harnesses/agent-progress.md`:

- the active feature id
- the exact pass gate
- the exact verification command or smoke check
- the stop/blocker conditions

If these items are not recorded, the session is not yet in valid run-to-pass mode.

Run-to-pass loop:

1. Read the active feature from `.effective-harnesses/feature_list.json`.
2. Confirm or infer the verification command or smoke-check target.
3. Implement the next bounded change for that same feature.
4. Run verification.
5. If verification fails, use the failure output to plan the next bounded fix.
6. Repeat until one of these is true:
   - verification passes
   - the feature is blocked by an external dependency, missing credential, missing environment, or unclear requirement
   - further automatic progress would require risky product or architecture decisions
7. Update `.effective-harnesses/feature_list.json` and `.effective-harnesses/agent-progress.md` with the exact result.

Stop conditions:

- set `passes: true` only when verification passes
- set `status: "blocked"` when a real blocker stops automatic progress
- never loop by making unrelated changes outside the active feature
- never silently weaken the verification target just to get a pass
- if the verification target must change, update the harness artifacts first and explain why the old gate was invalid

## `feature_list.json` contract

Use the canonical schema from `templates/feature-list.json`, but store it at `.effective-harnesses/feature_list.json` in the target repo.

Rules:

- Do not delete unfinished features unless the user explicitly changes scope.
- Do not rewrite a feature's intent silently.
- You may update `status`, `passes`, `verification`, `notes`, and `last_updated`.
- Add new features with stable IDs like `feat-001`, `feat-002`, and so on.
- Keep at most one feature in an active session state such as `in_progress`.
- When a new request supersedes the previous active feature, preserve the old feature and downgrade it to an appropriate non-active state before activating the new one.
- If a feature is completed but verification is still incomplete, prefer `status: "completed"` with `passes: false` and explain the gap.

## Commands supported by this skill

When the user asks for one of these tasks, follow the corresponding guide in `commands/`:

- harness bootstrap or adoption -> `commands/init.md`
- add a feature -> `commands/add-feature.md`
- activate or switch the active feature -> `commands/activate-feature.md`
- show harness status -> `commands/status.md`
- complete or verify a feature -> `commands/complete.md`
- run the active feature until it passes or blocks -> `commands/run-to-pass.md`

## AIFlow defaults

When used inside `AIFlow`, prefer these defaults unless the repo changes:

- backend startup: `./.venv/bin/python -m uvicorn backend.main:app --host 127.0.0.1 --port 8000`
- frontend startup: run from `frontend/`, prefer `npm run start:dev`
- baseline backend smoke check: `http://127.0.0.1:8000/docs` or a stable `/api/*` endpoint
- harness files live under `./.effective-harnesses/`
- verification should not assume `pytest tests/` is valid unless a real tests directory exists

For AIFlow requests that clearly ask to "keep fixing until pass rate/verification reaches a threshold", infer run-to-pass mode only after recording:

- the feature entry for that request
- the numeric threshold or other pass gate
- the exact verification command or endpoint
- the acceptable blocker class, such as missing credentials or external dependency failure

## References

Use the templates in `templates/` as the single source of truth for artifact structure.

For a human-oriented quick start and example prompts, see `references/usage.md`.
For the mandatory session start/end checklist, see `references/session-checklist.md`.
