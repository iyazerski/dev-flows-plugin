---
name: collect-context
description: Collect a compact Task Context Packet for a task, ticket, issue, PR, or pasted requirement before implementation or review. Use when Codex needs shared context for acceptance criteria, scope, existing patterns, affected files, risks, and validation.
---

# Collect Context

Gather enough context once so implementation and review can reuse it.

## Steps

1. Read the source of truth: ticket, issue, PR description, pasted requirement, docs, screenshots, or user notes.
2. Read relevant repo guidance, nearby docs, existing patterns, similar changes, symbols, call sites, tests, configs, migrations, and ownership boundaries.
3. Extract behaviour, acceptance criteria, non-goals, constraints, affected surface, risks, and validation commands.
4. Record uncertainty as open questions. Do not invent missing requirements.

Do not edit source files, commit, or post comments. If a loop artefact path is provided, write/update only `<loop artefact path>/task_context_packet.md`.

## Output

Return or persist a `Task Context Packet` with these sections:

```md
## Task Context Packet
Task: <summary and source refs>
Acceptance Criteria: <observable requirements>
Scope Boundaries: <in scope and out of scope>
Existing Patterns: <files, symbols, prior PRs, conventions>
Affected Surface: <files, modules, contracts, data paths>
Risks And Invariants: <important risks or guarantees>
Validation Plan: <minimal commands and what they prove>
Open Questions: <questions or "None">
```

Keep it factual and compact. Update existing sections instead of duplicating content.
