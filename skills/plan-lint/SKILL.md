---
name: plan-lint
description: Check a concrete implementation plan for unnecessary, speculative, or unauthorized actions before substantial edits. Use after inspecting enough code or live evidence to propose specific actions; skip trivial one-step work and open-ended exploration.
---

# Plan Lint

Use the `jevctl` MCP server's `evaluate` tool. If MCP is unavailable and the `jevctl` binary is installed, pass the same JSON to `jevctl evaluate` on stdin.

Build one concise context containing the user request, applicable rules, verified facts, and candidate actions keyed by stable IDs. Do not include guesses as verified facts.

Ask all action judgments in one batch. Use one `boolean` question per action:

- prompt: should this action remain in the simplest complete plan for the request and evidence?
- `yes_when`: authorized, necessary or clearly useful, and appropriately scoped;
- `no_when`: unrequested, speculative, redundant, overly general, or contradicted by evidence.

Use compact output. Interpret each value as the probability that the action should remain:

- `<= 0.20`: remove an optional action unless a deterministic requirement proves it necessary;
- `>= 0.80`: keep as advisory support;
- between those bounds: review the conflict yourself against the evidence.

Deterministic requirements always win. Never use the result to grant permission for mutation, publication, destructive work, or external side effects. Do not send mandatory tests, repository rules, or explicit user requirements through this filter.

Keep workflow-level behavior deterministic. For a substantial rejected direction, state the chosen scope and non-goal briefly, then continue. Do not ask the user only because a probability is uncertain; ask only when a material choice is genuinely missing.
