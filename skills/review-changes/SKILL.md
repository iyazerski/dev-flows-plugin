---
name: review-changes
description: Produce a detailed internal review of local uncommitted, staged, or branch changes against task context. Use before a PR or inside a development loop when Codex needs evidence, fix guidance, validation notes, scope checks, and loop-ready findings; not for remote PR checkout or short GitHub comments.
---

# Review Changes

Review the local diff against the task context. Prioritize actionable issues that could change behavior, break contracts, or leave the task incomplete.

## Rules

- Use the task context packet as the review baseline. Ask one concise question if no task context is available.
- Verify each context claim before using it as finding evidence.
- Do not edit files, stage, commit, push, post comments, approve, or request changes.
- When a loop artefact path is provided, write/update only `<loop artefact path>/code_review.md`.

## Review Lens

- Task fit, correctness, regressions, validation gaps, contracts, data, security, performance, permissions, and tests.
- Sibling alignment: compare with nearby or similar implementations and flag missing mirrored behaviour, logs, metrics, config, fixtures, tests, error handling, naming, or rollout patterns.
- Boundary behaviour: verify auth failures, wrong credentials, missing or unauthorized resources, malformed payloads, empty/null/blank values, no-op inputs, success paths, expected failures, and observability side effects.
- Architecture boundaries: verify business rules, validation rules, orchestration, serializers, handlers, domain code, application use cases, and infrastructure adapters live in the same layers as sibling implementations.
- Observability and privacy: verify logs, events, metrics, tool results, extra payloads, sanitation/redaction settings, and PII exposure match local conventions.
- Cross-surface parity: compare backend validation and customer-facing messages with frontend validation, vendor tool input shape, natural-language capture, docs, or journey configuration when those surfaces exist.
- Scope creep: unrequested methods, fields, settings, schema changes, abstractions, dependencies, branches, fallbacks, public contracts, formatting churn, dead code, or ownership creep.
- Checks: run only the smallest useful commands. Prove suspected issues or drop them.

## Mandatory Gates

Before returning `PASS`, actively check and record evidence for all gates below. If evidence is missing, return `NEEDS_CHANGES` or `BLOCKED`; do not assume the implementation is fine.

1. Contract shape: for public, webhook, API, event, CLI, or cross-system changes, compare the diff with sibling implementations and tests. Flag extra, missing, duplicated, renamed, or differently nested request fields, response fields, serializers, response serializers, error details, status codes, headers, auth handling, event payloads, log payloads, and persistence side effects.
2. Boundary coverage: verify tests or checks cover the contract's important edges: missing and wrong auth, missing resources, unverified or unauthorized states, malformed payloads, empty/null/blank values, no supplied work, success, expected failure, and observability side effects. Flag missing boundary coverage when sibling implementations cover it or the contract exposes it.
3. Layer ownership: inspect new business rules, validation rules, parsing, orchestration, IO, and persistence. Flag domain or application logic placed in interface handlers, serializers, views, commands, or adapters when sibling patterns put it in use cases, domain modules, services, or shared validation code.
4. Observability and privacy: inspect every new or changed log, event, metric, tracking result, extra payload, and exception path. Flag PII exposure, missing redaction or sanitation settings, inconsistent event names/status values/error messages, and mismatches between operational logs and customer/tool results.
5. Reuse over reinvention: inspect every new generic-looking helper, validator, parser, normaliser, enum, serializer, response serializer, fixture, factory helper, constant, or service. Search for shared equivalents and flag local reimplementation unless the task packet proves the shared code does not fit.
6. Convention and lint alignment: inspect new imports, lint suppressions, fixtures, factories, constants, messages, and test setup. Flag banned imports, avoidable `noqa`, hidden database writes in pytest fixtures, scattered user-facing strings, and validation messages that do not match local style.
7. Duplication and dead code: compare newly added functions and branches with each other and with nearby code. Flag near-duplicate helpers, single-use abstractions, obsolete branches, unused constants, and compatibility paths that are not required.
8. Customer-facing tolerance: check inputs a customer, frontend, integration, vendor tool, or external agent may provide for needless case sensitivity, whitespace brittleness, backend enum leakage, overly strict formatting, unclear natural-language handling, or confusing validation messages. Flag issues like accepting `Employed` but rejecting `employed` unless the requirement explicitly demands it.
9. Pattern mirroring: verify names, docstrings, comments, error wording, logging, metrics, tests, data setup, and validation style match the local codebase rather than a generic preferred style.

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

Then include checks run, context reviewed, scope notes, and notable non-findings. In `code_review.md`, keep stable finding titles and mark each as `open`, `fixed`, `accepted`, or `dropped`. Do not paste full diffs, full logs, or repeated findings.
