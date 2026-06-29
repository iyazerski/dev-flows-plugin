---
name: implement-task
description: Run a task from requirements to PR-ready local changes by collecting context, implementing the smallest scoped change, reviewing, fixing findings, and repeating until requirements are met with no actionable review.
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
```

Replace `/`, whitespace, and unusual branch-name characters with `-`. These files belong only under that path. If the path would be tracked, prefer an existing ignored temp location.

Persist only compact, decision-useful notes. Do not dump full logs, full diffs, repeated findings, secrets, tokens, customer data, or large generated output.

## Loop

1. Reread existing artefacts before each pass.
2. Use `collect-context` to create or refresh the task context packet from the task, source refs, repo root, current branch, changed-file hints if known, and loop artefact path.
3. Read the packet before editing. If `Expected Contracts`, `Existing Patterns`, or `Reuse Inventory` are thin for the files you will touch, do targeted research and update the packet.
4. Write or refresh `<loop artefact path>/implementation_plan.md` with the smallest concrete change that satisfies the acceptance criteria.
5. Implement the plan. Update the plan first if the implementation needs to change direction.
6. Run pre-commit hooks on the changed files.
7. Use `review-changes` to review the local diff against the task packet, implementation plan, changed files, diff scope, repo guidance, and loop artefact path.
8. Fix accepted findings. Mark review findings `open`, `fixed`, `accepted`, or `dropped`.
9. Repeat until the exit criteria pass.
10. Handoff with changed files, checks, review result, artefact paths, and tradeoffs.

Do not commit, push, branch, or open a PR unless explicitly asked.

## Exit Criteria

- Acceptance criteria are met.
- The changed-file pre-commit run passes.
- No P0/P1/P2 findings remain.
- P3 findings are fixed or accepted as tradeoffs.
- The diff contains no unnecessary methods, fields, settings, schema changes, abstractions, dependencies, fallback branches, dead code, duplicated helpers, local reimplementations of shared code, or formatting churn.
- Public and external contracts have been compared with sibling implementations.

Ask the user when requirements conflict, key context is unavailable, or the same issue survives two fix attempts.

## Plan Shape

Keep `implementation_plan.md` terse and operational:

```md
## Implementation Plan
Goal: <one sentence>
Files: <expected files/modules>
Steps:
- <small concrete step>
- <small concrete step>
Review Focus: <contracts, layer placement, boundary cases, observability/privacy, risks to verify>
Open Questions: <questions or "None">
```

Update the plan when implementation reality changes. Do not turn it into a design document.
