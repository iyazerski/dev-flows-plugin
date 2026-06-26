---
name: implement-task
description: Run a task from requirements to PR-ready local changes by collecting context, implementing the smallest scoped change, validating locally, reviewing, fixing findings, and repeating until requirements are met with no actionable review or validation issues.
---

# Implement Task

Drive one task to a PR-ready local diff. Keep the loop compact, scoped, and resumable.

## Artefacts

Create or reuse exactly one loop artefact path:

```text
tmp/dev-loops/<safe-branch-name>/
  task_context_packet.md
  implementation_plan.md
  code_review.md
  loop_log.md
```

Replace `/`, whitespace, and unusual branch-name characters with `-`. These files belong only under that path. If the path would be tracked, prefer an existing ignored temp location.

Persist only compact, decision-useful notes. Do not dump full logs, full diffs, repeated findings, secrets, tokens, customer data, or large generated output.

## Loop

1. Reread existing artefacts before each pass.
2. Use `collect-context` to create or refresh the task context packet from the task, source refs, repo root, current branch, changed-file hints if known, and loop artefact path.
3. Read the packet before editing. If `Expected Contracts`, `Existing Patterns`, or `Reuse Inventory` are thin for the files you will touch, do targeted research and update the packet.
4. Write or refresh `<loop artefact path>/implementation_plan.md` with the smallest concrete change that satisfies the acceptance criteria.
5. Implement the plan. Update the plan first if the implementation needs to change direction.
6. Run validation and append a terse summary to `loop_log.md`. If a pre-commit config exists, run only pre-commit on the changed files unless a specific extra check is required by the task or failure risk.
7. Use `review-changes` to review the local diff against the task packet, implementation plan, changed files, diff scope, validation summary, repo guidance, and loop artefact path.
8. Fix accepted findings. Mark review findings `open`, `fixed`, `accepted`, or `dropped`.
9. Repeat until the exit criteria pass.
10. Handoff with changed files, checks, review result, artefact paths, and tradeoffs.

Do not commit, push, branch, or open a PR unless explicitly asked.

## Exit Criteria

- Acceptance criteria are met.
- Relevant validation passes, or the blocker is explained.
- No P0/P1/P2 findings remain.
- P3 findings are fixed or accepted as tradeoffs.
- The diff contains no unnecessary methods, fields, settings, schema changes, abstractions, dependencies, fallback branches, dead code, duplicated helpers, local reimplementations of shared code, or formatting churn.
- Public and external contracts have been compared with sibling implementations.

Ask the user when requirements conflict, key context is unavailable, validation is blocked, or the same issue survives two fix attempts.

## Plan Shape

Keep `implementation_plan.md` terse and operational:

```md
## Implementation Plan
Goal: <one sentence>
Files: <expected files/modules>
Steps:
- <small concrete step>
- <small concrete step>
Validation: <commands/checks>
Review Focus: <contracts, layer placement, boundary cases, observability/privacy, validation parity, risks to verify>
Open Questions: <questions or "None">
```

Update the plan when implementation reality changes. Do not turn it into a design document.

## Log Shape

Use compact entries in `loop_log.md`:

```md
## <timestamp or round>
Changed: <summary>
Validation: `<command>`: <passed/failed/blocked>
Review: <finding status changes or "No actionable findings">
Next: <next step>
```
