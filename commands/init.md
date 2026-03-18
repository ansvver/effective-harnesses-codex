# Harness Bootstrap / Adoption

Use this flow when the user wants to initialize or adopt the current project into a long-running harness.

## Goal

Create durable harness artifacts that let future Codex sessions recover state quickly and make incremental progress.

## Procedure

1. Detect whether the repo is new or existing.
2. Inspect manifests, repo docs, and scripts to infer:
   - project name
   - startup command or commands
   - strongest available verification method
3. Only ask the user for missing information that cannot be derived safely.
4. Create or update:
   - `.effective-harnesses/feature_list.json`
   - `.effective-harnesses/agent-progress.md`
   - `.effective-harnesses/HARNESS.md`
   - `.effective-harnesses/init.sh` if startup automation is useful
5. If `claude-progress.txt` exists, preserve it and reference it from `.effective-harnesses/agent-progress.md`.
6. If the repo is new and not under git, initialize git and make the initial harness commit.
7. If the repo already exists under git, do not run `git init`; commit only if the user wants the harness artifacts committed now.

## Startup inference

Prefer repo-derived commands in this order:

- repo guidance docs such as `CLAUDE.md`, `AGENTS.md`, `README.md`
- root scripts like `start_backend.sh`, `start.sh`, `dev.sh`
- `package.json` scripts
- Python entrypoints such as `uvicorn`, `manage.py`, `flask`, `fastapi`
- `docker-compose` or `Makefile`

If multiple services exist, write `init.sh` as a commented launcher that documents the expected startup sequence rather than forcing one fragile command.

## Verification inference

Prefer this order:

1. real automated tests
2. build or static validation
3. smoke checks against stable local endpoints or CLI commands
4. manual verification notes

## Output requirements

After bootstrap or adoption, the repo should have:

- a canonical feature registry with zero or more initial features
- a progress file with project summary and current focus
- a concise harness note describing how future sessions should get bearings
- a startup helper when it adds real value
- all stored under `.effective-harnesses/`
