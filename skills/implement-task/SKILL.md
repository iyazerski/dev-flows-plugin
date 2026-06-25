---
name: implement-task
description: Run a task from requirements to PR-ready local changes by collecting context, implementing the smallest scoped change, validating locally, reviewing, fixing findings, and repeating until requirements are met with no actionable review or validation issues.
---

# Implement Task

Drive one task to a PR-ready local diff. Keep the loop compact, resumable, and scoped.

## Artefacts

Create or reuse exactly one loop artefact path:

```text
tmp/dev-loops/<safe-branch-name>/
  task_context_packet.md
  code_review.md
  loop_log.md
```

Replace `/`, whitespace, and unusual branch-name characters with `-`. These three files belong only under that path. If the path would be tracked, prefer an existing ignored temp location.

Persist only compact, decision-useful notes. Do not dump full logs, full diffs, repeated findings, secrets, tokens, customer data, or large generated output.

## Loop

1. Reread existing artefacts before each pass.
2. Spawn a context subagent using the `collect-context` skill. Pass the task, source refs, repo root, current branch, changed-file hints if known, and loop artefact path. Wait until it finishes and creates the `<loop artefact path>/task_context_packet.md`.
3. Review the packet before editing. If `Expected Contracts`, `Existing Patterns`, or `Reuse Inventory` are thin for the files you will touch, ask the context subagent a focused follow-up or do targeted research yourself and update the packet.
3. Plan and implement the smallest change that satisfies the acceptance criteria.
5. Run validation and append a terse summary to `loop_log.md`. If a pre-commit config exists, run only pre-commit on the changed files unless a specific extra check is required by the task or failure risk.
6. Spawn a review subagent using the `review-changes` skill. Pass the task packet, changed files, diff scope, validation summary, repo guidance, and loop artefact path.
7. Fix accepted findings. Mark review findings `open`, `fixed`, `accepted`, or `dropped`.
8. Repeat until the exit criteria pass.
9. Handoff with changed files, checks, review result, artefact paths, and tradeoffs.

Do not commit, push, branch, or open a PR unless explicitly asked.

## Exit Criteria

- Acceptance criteria are met.
- Relevant validation passes, or the blocker is explained.
- No P0/P1/P2 findings remain.
- P3 findings are fixed or accepted as tradeoffs.
- The diff contains no unnecessary methods, fields, settings, schema changes, abstractions, dependencies, fallback branches, dead code, duplicated helpers, local reimplementations of shared code, or formatting churn.
- Public and external contracts have been compared with sibling implementations.

Ask the user when requirements conflict, key context is unavailable, validation is blocked, or the same issue survives two fix attempts.

## Log Shape

Use compact entries in `loop_log.md`:

```md
## <timestamp or round>
Changed: <summary>
Validation: `<command>`: <passed/failed/blocked>
Review: <finding status changes or "No actionable findings">
Next: <next step>
```
