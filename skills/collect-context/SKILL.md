---
name: collect-context
description: Collect a compact Task Context Packet for a task, ticket, issue, PR, or pasted requirement before implementation or review. Use when Codex needs shared context for acceptance criteria, scope, existing patterns, affected files, risks, and validation.
---

# Collect Context

Build a compact task context packet that implementation and review can rely on.

## Workflow

1. Read the source of truth: ticket, issue, PR description, pasted requirement, docs, screenshots, or user notes.
2. Read the relevant repo guidance, nearby docs, existing patterns, similar changes, symbols, call sites, tests, configs, migrations, and ownership boundaries.
3. Identify the observable acceptance criteria, non-goals, affected surface, risks, invariants, and smallest useful validation commands.
4. Prove expected contracts before implementation: request shapes, response shapes, serializers or schemas, status codes, error payloads, auth, permissions, idempotency, side effects, data persistence, logging, events, metrics, and privacy requirements.
5. Compare public, external, webhook, tool, API, event, or cross-system changes with at least one sibling implementation. Capture exact sibling conventions for error text, status strings, call/resource verification, event payloads, log fields, and test coverage.
6. Identify architecture boundaries before planning code placement. Separate interface handlers, serializers, application use cases, domain logic, shared validation modules, and infrastructure adapters using nearby examples as evidence.
7. Build a reuse inventory before proposing new helpers: shared validators, serializers, response serializers, forms, enums, TextChoices, normalisers, domain services, adapters, config hooks, constants, fixtures, factories, and test helpers.
8. Search semantically first when the repo provides a semantic tool, then use targeted text search for exact concepts, banned imports, lint exceptions, user-facing labels, event names, error messages, and status values.
9. Capture mirrored behaviour that must stay consistent: case sensitivity, whitespace handling, nullable/blank handling, empty input handling, choice labels versus backend enum keys, date parsing, phone/email/name rules, duplicated response fields, metrics, events, audit logs, tests, and customer-visible message style.
10. For customer, agent, voice, webhook, or UI-adjacent validation, compare backend rules with the source customers actually interact with: frontend validation, vendor tool input shape, natural-language capture, docs, or existing journey configuration.
11. Build a boundary test matrix for auth failures, wrong credentials, missing resources, unverified or unauthorized states, malformed payloads, empty/null/blank values, no-op inputs, success paths, expected failures, and observability side effects.
12. Map privacy-sensitive data before implementation. Identify PII fields, safe log/event fields, required redaction or sanitation settings, and differences between customer/tool results and operational logs.
13. Record uncertainty as open questions. Do not invent missing requirements.

Do not edit source files, commit, or post comments. When a loop artefact path is available, write or update only `<loop artefact path>/task_context_packet.md`.

## Output

Return or persist one `Task Context Packet` with these sections:

```md
## Task Context Packet
Task: <summary and source refs>
Acceptance Criteria: <observable requirements>
Scope Boundaries: <in scope and out of scope>
Expected Contracts: <request/response/event/log/auth/privacy/data contracts with evidence>
Existing Patterns: <files, symbols, prior PRs, architecture boundaries, conventions and what must be mirrored>
Reuse Inventory: <shared APIs/helpers/enums/validators to use, or evidence none fit>
Affected Surface: <files, modules, contracts, data paths>
Risks And Invariants: <important risks or guarantees>
Validation Plan: <minimal commands, boundary cases, and what they prove>
Open Questions: <questions or "None">
```

Keep the packet factual, compact, and evidence-backed. Every contract or reuse claim must name a file, symbol, command, ticket, or document. Update existing sections instead of duplicating content.
