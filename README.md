# Effective Harnesses Codex

An opinionated, Codex-optimized evolution of the effective harness workflow for long-running agent sessions.

This repository turns the core ideas from Anthropic's long-running agent harnesses into a more operational workflow for Codex: one active feature at a time, durable state across sessions, explicit verification, and clean handoff artifacts that let work continue without reloading the entire project into context.

Built on top of:

- https://github.com/Suibosama/effective-harnesses
- https://www.anthropic.com/engineering/effective-harnesses-for-long-running-agents

Thanks to both for the original framing, structure, and inspiration.

## Why This Exists

Long-running coding work usually breaks down in predictable ways:

- the active task drifts across sessions
- verification gets skipped or weakened
- the agent starts working from memory instead of durable project state
- a new request silently collides with unfinished work
- the next session has to reconstruct what happened from scattered commits and terminal output

`effective-harnesses-codex` is designed to reduce that failure mode. It gives Codex a strict, repo-local operating loop so progress is durable, auditable, and easier to continue.

## The Core Mechanism

The overall mechanism follows the harness pattern described by Anthropic:

1. Persist important working state to files inside the repo.
2. Re-read that state at the start of each session.
3. Work on one clearly defined unit at a time.
4. Verify before claiming success.
5. Leave structured notes so the next session can resume quickly.

In this repository, those ideas are implemented with a practical file-based workflow under `.effective-harnesses/`:

- `feature_list.json`: the durable source of truth for tracked work
- `agent-progress.md`: session log, current focus, and handoff notes
- `init.sh`: optional repo-specific startup/bootstrap helper
- `HARNESS.md`: concise local instructions for future sessions

The result is a simple rule: Codex should not rely on memory when the repo can carry the state.

## Why This Version Is Different

This is not just a direct port. It is a Codex-first refinement intended to be stricter in execution and more useful in real repositories.

Key improvements in this version:

- Codex-oriented operating rules rather than Claude-specific prompting assumptions
- explicit single-active-feature protocol to prevent silent task switching
- stronger verification policy that separates `completed` from `passes: true`
- run-to-pass mode for bounded iterative fixing until a real gate passes or a true blocker is reached
- existing-repo adoption flow so the harness can wrap mature codebases without pretending they are greenfield
- hidden `.effective-harnesses/` storage to avoid root-level file clutter and name collisions
- durable session checklist and human-readable usage references
- repo discovery heuristics for startup and verification commands before asking the user
- stricter handoff-clean expectations before commit boundaries

## What You Get

- A reusable skill for multi-session engineering work
- A disciplined way to break work into durable features
- A repeatable session bootstrap and shutdown rhythm
- A safer loop for autonomous iteration with explicit stop conditions
- Better continuity for solo work and for collaborative agent-assisted development

## Installation

```bash
git clone git@github.com:ansvver/effective-harnesses-codex.git ~/.codex/skills/effective-harnesses
```

## Typical Use

Tell Codex:

- `Use effective-harnesses to adopt this repository.`
- `Use effective-harnesses to add a feature: improve the backend smoke checks.`
- `Use effective-harnesses to complete feat-002.`
- `Use effective-harnesses to run feat-003 to pass.`
- `Use effective-harnesses to summarize project progress.`

For a more guided walkthrough, see `references/usage.md`.

## Repository Structure

```text
.
├── SKILL.md
├── commands/
│   ├── add-feature.md
│   ├── complete.md
│   ├── init.md
│   ├── run-to-pass.md
│   └── status.md
├── references/
│   ├── session-checklist.md
│   └── usage.md
└── templates/
    ├── HARNESS.md
    ├── agent-progress.md
    ├── feature-list.json
    └── init.sh
```

## Who This Is For

This project is a strong fit if you want:

- a cleaner workflow for long-running implementation tasks
- a durable record of what an agent is doing and why
- more reliable continuation across sessions
- a stricter verification discipline for agent-driven coding
- a shared process that others can inspect, improve, and extend

## Contributing

If you think agent workflows should be more reproducible and less hand-wavy, contributions are useful here.

Good contribution areas:

- improve the command flows in `commands/`
- strengthen the templates in `templates/`
- add sharper real-world examples in `references/`
- tighten verification and recovery rules for more repo types
- refine the Codex interaction model without making it heavier

If this workflow is useful, star the repo and open an issue or PR. The goal is to make long-running agent work more disciplined, more transferable, and easier for others to build on.
