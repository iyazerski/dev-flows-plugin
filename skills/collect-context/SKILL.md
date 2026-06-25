---
name: collect-context
description: Collect a compact Task Context Packet for a task, ticket, issue, PR, or pasted requirement before implementation or review. Use when Codex needs shared context for acceptance criteria, scope, existing patterns, affected files, risks, and validation.
---

# Collect Context

Gather enough context once so implementation and review can reuse it.

## Steps

1. Read the source of truth: ticket, issue, PR description, pasted requirement, docs, screenshots, or user notes.
2. Read repo guidance, nearby docs, existing patterns, similar changes, symbols, call sites, tests, configs, migrations, and ownership boundaries.
3. Prove the expected contracts before implementation: request and response shapes, status codes, error payloads, logging/events, auth, permissions, idempotency, side effects, and data persistence. Compare against at least one sibling implementation when the change touches a public or cross-system interface.
4. Build a reuse inventory before proposing new helpers: shared validators, serializers, forms, enums, TextChoices, normalisers, domain services, adapters, config hooks, fixtures, factories, and test helpers. Search semantically first when the repo provides a semantic tool, then use targeted text search for exact concepts and user-facing labels.
5. Identify mirrored behaviour: case sensitivity, whitespace handling, nullable/blank handling, choice labels versus backend enum keys, date parsing, phone/email/name rules, duplicated response fields, metrics, events, audit logs, and tests.
6. Extract behaviour, acceptance criteria, non-goals, constraints, affected surface, risks, and validation commands.
7. Record uncertainty as open questions. Do not invent missing requirements.

Do not edit source files, commit, or post comments. If a loop artefact path is provided, write/update only `<loop artefact path>/task_context_packet.md`.

## Output

Return or persist a `Task Context Packet` with these sections:

```md
## Task Context Packet
Task: <summary and source refs>
Acceptance Criteria: <observable requirements>
Scope Boundaries: <in scope and out of scope>
Expected Contracts: <request/response/event/auth/data contracts with evidence>
Existing Patterns: <files, symbols, prior PRs, conventions and what must be mirrored>
Reuse Inventory: <shared APIs/helpers/enums/validators to use, or evidence none fit>
Affected Surface: <files, modules, contracts, data paths>
Risks And Invariants: <important risks or guarantees>
Validation Plan: <minimal commands and what they prove>
Open Questions: <questions or "None">
```

Keep it factual and compact. Every contract or reuse claim must include file, symbol, command, ticket, or documentation evidence. Update existing sections instead of duplicating content.
