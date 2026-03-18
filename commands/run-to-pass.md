# Run To Pass

Use this flow when the user wants Codex to keep executing the active feature until verification passes or a real blocker is reached.

## Goal

Stay on one feature and iterate implementation plus verification until the feature is either:

- passing
- blocked for a concrete external reason
- stopped because more autonomous progress would require unsafe assumptions

## Preconditions

Before entering this mode:

1. Read `.effective-harnesses/feature_list.json`.
2. Confirm that the user actually wants run-to-pass behavior, not just a normal implementation pass.
3. Activate the target feature using `commands/activate-feature.md`:
   - prefer a feature already marked `in_progress`
   - otherwise explicitly activate the correct feature before proceeding
4. Make sure the feature has a verification target:
   - a command
   - a build check
   - a smoke-check URL or CLI target
   - or an explicit statement that the feature cannot yet be auto-verified
5. Confirm the pass condition and stop condition if they are not already obvious from the repo or harness state.
6. Record in `.effective-harnesses/agent-progress.md`:
   - active feature id
   - exact pass gate
   - exact verification command or smoke check
   - blocker policy

If the user request, pass condition, or blocker policy is unclear, ask before starting the loop.

If no reasonable verification target exists, do not pretend run-to-pass is possible. First create or strengthen the verification plan.

## Loop

Repeat this cycle for the same feature:

1. Run the current verification target.
2. Inspect the failure output or missing behavior.
3. Make one bounded implementation change aimed at that failure.
4. Re-run verification.
5. Update the feature notes if the verification target or blocker becomes clearer.

## Rules

- Do not switch to another feature mid-loop unless the user explicitly reprioritizes.
- Do not broaden scope while fixing verification failures.
- Prefer the smallest change that moves the feature closer to a verified pass.
- Keep the verification target stable; only change it if the old target was clearly wrong, and record why.
- If the loop exposes a missing baseline test or smoke check, that may justify a new supporting feature after the current one is stabilized.
- Re-run the activation flow before continuing if the feature target changes for any reason.

## Exit conditions

### Pass

Set:

- `status: "completed"`
- `passes: true`
- `verification.status: "passed"`

Then record the final passing command or check in `verification.summary`.

### Blocked

Set:

- `status: "blocked"`
- `passes: false`

And record the exact blocker in `notes`, such as:

- missing credential
- unavailable service
- missing fixture data
- ambiguous product requirement
- dependency bug outside the current feature

### Partial completion

If implementation is done but verification still fails:

- keep the feature as `completed` only if the feature work itself is finished
- keep `passes: false`
- record the failing verification state honestly

## Typical user prompts

- `Use effective-harnesses to run feat-002 to pass.`
- `Keep working on the current feature until verification passes.`
- `Continue the active harness feature until it is either passing or blocked.`

## Questions to ask when needed

Ask concise questions before running when any of these are missing:

- target feature
- passing condition
- verification target
- blocker policy

Examples:

- `Do you want normal implementation or run-to-pass for feat-002?`
- `What should count as "passed" for this feature: a test command, a build, or a smoke-check endpoint?`
- `If the loop hits a missing credential or external dependency, should I stop and mark blocked?`
