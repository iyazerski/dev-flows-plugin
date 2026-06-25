---
name: review-changes
description: Produce a detailed internal review of local uncommitted, staged, or branch changes against task context. Use before a PR or inside a development loop when Codex needs evidence, fix guidance, validation notes, scope checks, and loop-ready findings; not for remote PR checkout or short GitHub comments.
---

# Review Changes

Review the local diff against the task context. Verify any context claim before using it as finding evidence.

## Rules

- Do not gather broad task context from scratch. Ask one concise question if no task context is available.
- Do not edit files, stage, commit, push, post comments, approve, or request changes.
- When a loop artefact path is provided, write/update only `<loop artefact path>/code_review.md`.

## Review Lens

- Task fit, correctness, regressions, validation gaps, contracts, data, security, performance, permissions, and tests.
- Sibling alignment: compare with nearby or similar implementations and flag missing mirrored behaviour, logs, metrics, config, fixtures, tests, error handling, naming, or rollout patterns.
- Scope creep: unrequested methods, fields, settings, schema changes, abstractions, dependencies, branches, fallbacks, public contracts, formatting churn, dead code, or ownership creep.
- Run only the smallest useful checks. Prove or drop suspected issues.

## Mandatory Gates

Before returning `PASS`, actively check and record evidence for all gates below. If evidence is missing, return `NEEDS_CHANGES` or `BLOCKED`; do not assume the implementation is fine.

1. Contract shape: for public, webhook, API, event, CLI, or cross-system changes, compare the diff with sibling implementations and tests. Flag extra, missing, duplicated, renamed, or differently nested response fields, error details, status codes, headers, auth handling, event payloads, and persistence side effects.
2. Reuse over reinvention: inspect every new generic-looking helper, validator, parser, normaliser, enum, serializer, fixture, or service. Search for shared equivalents and flag local reimplementation unless the task packet proves the shared code does not fit.
3. Duplication and dead code: compare newly added functions and branches with each other and with nearby code. Flag near-duplicate helpers, single-use abstractions, obsolete branches, unused constants, and compatibility paths that are not required.
4. Customer-facing tolerance: check inputs a customer or external agent may provide for needless case sensitivity, whitespace brittleness, backend enum leakage, overly strict formatting, or confusing validation messages. Flag issues like accepting `Employed` but rejecting `employed` unless the requirement explicitly demands it.
5. Pattern mirroring: verify names, docstrings, comments, error wording, logging, metrics, tests, and validation style match the local codebase rather than a generic preferred style.

## Output

Lead with:

```md
## Review Result
Status: PASS / NEEDS_CHANGES / BLOCKED
Summary: <overall judgement>
```

For each finding:

```md
### Finding N: <title>
Severity: P0/P1/P2/P3
Category: <task fit/correctness/scope/tests/data/security/performance/contract/maintainability>
Location: `<path>:<line>` or `<path>`
Loop action: Fix / Clarify / Accept tradeoff / No action

Issue: <what is wrong>
Evidence: <verified code, behaviour, command, or task evidence>
Impact: <why it matters>
Suggested fix: <smallest useful change>
Validation: <how to prove the fix>
```

Then include checks run, context reviewed, scope notes, and notable non-findings. In `code_review.md`, keep stable finding titles and mark each as `open`, `fixed`, `accepted`, or `dropped`; do not paste full diffs, full logs, or repeated findings.
