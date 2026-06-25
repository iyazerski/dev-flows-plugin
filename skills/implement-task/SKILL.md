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
2. Collect context with `collect-context`, passing the loop artefact path.
3. Plan and implement the smallest change that satisfies the acceptance criteria.
4. Run the minimal relevant validation and append a terse summary to `loop_log.md`.
5. Review with `review-changes`, passing the task packet and loop artefact path.
6. Fix accepted findings. Mark review findings `open`, `fixed`, `accepted`, or `dropped`.
7. Repeat until the exit criteria pass.
8. Handoff with changed files, checks, review result, artefact paths, and tradeoffs.

Do not commit, push, branch, or open a PR unless explicitly asked.

## Exit Criteria

- Acceptance criteria are met.
- Relevant validation passes, or the blocker is explained.
- No P0/P1/P2 findings remain.
- P3 findings are fixed or accepted as tradeoffs.
- The diff contains no unnecessary methods, fields, settings, schema changes, abstractions, dependencies, fallback branches, dead code, or formatting churn.

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
