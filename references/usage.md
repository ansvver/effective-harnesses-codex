# Effective Harnesses Usage

This is the quick start for humans using the `effective-harnesses` skill.

## What it is for

Use this skill when you want Codex to manage a long-running project across many sessions with durable progress tracking.

It is best for:

- existing repos that need session recovery and structured feature tracking
- new repos that should start with a lightweight harness
- projects where you want one feature at a time, explicit verification, and handoff notes
- features you want Codex to keep iterating on until automated checks pass

## What files it creates

The skill manages these files in the target repo:

- `.effective-harnesses/feature_list.json`: the source of truth for planned and completed features
- `.effective-harnesses/agent-progress.md`: a readable session log and current focus
- `.effective-harnesses/init.sh`: a project bootstrap script when local startup matters
- `.effective-harnesses/HARNESS.md`: short repo-specific instructions for future sessions

If the repo already has `claude-progress.txt`, the skill can read it during adoption but will use `.effective-harnesses/agent-progress.md` going forward.

Runtime rule:

- `.effective-harnesses/init.sh` may safely clean stale runtime pid markers before startup
- it should not automatically stop active local services unless the user explicitly requests cleanup or stop

Interaction rule:

- if the feature request or verification target is unclear, Codex should pause and ask before executing
- if the user says "keep going" or "run until done", Codex should confirm whether they mean run-to-pass

## Common things to say

### 1. Adopt an existing repo

Examples:

- `Use effective-harnesses to adopt this repository.`
- `Bootstrap a long-running harness for this repo.`
- `Set up effective-harnesses for the current project.`

What Codex should do:

- detect that the repo already exists
- inspect startup and verification commands from the repo
- create harness files without reinitializing git
- keep those harness files under `.effective-harnesses/`

### 2. Initialize a new project

Examples:

- `Use effective-harnesses to initialize this new project.`
- `Bootstrap a new harness for this directory.`

What Codex should do:

- detect that the directory is effectively new
- create the harness files
- optionally initialize git if the repo is not already under git

### 3. Add a feature

Examples:

- `Use effective-harnesses to add a feature: update the README to match the real stack.`
- `Add a bugfix feature for backend smoke tests.`

What Codex should do:

- read `.effective-harnesses/feature_list.json`
- create the next `feat-XXX`
- store category, priority, steps, and verification plan

If the request is vague, Codex should ask for:

- the concrete expected outcome
- the rough scope boundary
- what should count as passed

### 4. Show status

Examples:

- `Show the current harness status.`
- `Use effective-harnesses to summarize project progress.`

What Codex should do:

- read `.effective-harnesses/feature_list.json`
- read `.effective-harnesses/agent-progress.md`
- read recent git history
- tell you which feature is current and what should happen next

### 5. Complete or verify a feature

Examples:

- `Use effective-harnesses to complete feat-002.`
- `Verify feat-003 and update its status.`

What Codex should do:

- run the strongest available verification
- update `status`, `passes`, and verification notes honestly
- avoid marking a feature as passed without evidence

If completion policy is unclear, Codex should ask whether:

- manual verification is acceptable
- failed verification should leave the feature as `completed` but non-passing
- the feature should instead be marked `blocked`

### 6. Finish one feature and start the next one

This is the normal way to handle a new request after finishing the current feature.

Example sequence:

- `Use effective-harnesses to complete feat-001.`
- `Use effective-harnesses to add a feature: support exporting analysis results as markdown.`
- `Continue the harness and start feat-002.`

What Codex should do:

- finish verification and status updates for the current feature
- append a new `feat-XXX` entry for the new request
- make the new feature the active focus for the next session or implementation step

Important rule:

- do not mix unfinished work from one feature into another without updating the harness state first

### 7. Keep running until a feature passes

Use this when you want Codex to stay on the same feature and keep fixing it until the verification target passes.

Examples:

- `Use effective-harnesses to run feat-002 to pass.`
- `Keep working on the current harness feature until verification passes.`
- `Continue the active feature until it is passing or blocked.`

What Codex should do:

- stay on one active feature
- run the verification target
- use failures to drive the next bounded fix
- repeat until the feature passes or a real blocker is reached

Important rules:

- this works best when the feature has a real test, build check, or smoke-check target
- Codex should not silently relax the verification target just to claim success
- if no useful verification target exists yet, Codex should first strengthen the verification plan instead of faking run-to-pass
- if the user has not clearly asked for run-to-pass, Codex should confirm that mode before starting it
- if the pass condition is vague, Codex should ask what "done" means before entering the loop

## Session rhythm

For a repo already using the harness, a normal session should look like this:

1. Read `.effective-harnesses/agent-progress.md`
2. Read `.effective-harnesses/feature_list.json`
3. Read recent `git log`
4. Run `.effective-harnesses/init.sh` if present
5. Verify the baseline before editing code
6. Work on exactly one feature
7. Re-run relevant verification
8. Update the harness files before ending the session

In run-to-pass mode, steps 5 to 7 repeat until the feature passes or blocks.

## How verification works

The skill prefers:

1. automated tests
2. build or typecheck checks
3. startup plus HTTP, CLI, or API smoke checks
4. manual verification

Important rule:

- `status: "completed"` means the implementation is done
- `passes: true` means verification actually passed

Those are not the same thing.

## AIFlow example

Inside `AIFlow`, the current verified baseline is:

- backend: `./.effective-harnesses/init.sh backend`
- frontend: `./.effective-harnesses/init.sh frontend`
- backend smoke check: `curl http://127.0.0.1:8000/docs`
- frontend smoke check: `curl http://127.0.0.1:3000/`

If both endpoints return `200`, the harness baseline is healthy.
