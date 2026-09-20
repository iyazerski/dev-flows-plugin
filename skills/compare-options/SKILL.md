---
name: compare-options
description: Compare two to six concrete implementation options against verified requirements and scope. Use after investigation leaves several viable alternatives; do not use to invent options or replace exact deterministic checks.
---

# Compare Options

Use the `jevctl` MCP server's `evaluate` tool. If MCP is unavailable and the `jevctl` binary is installed, pass the same JSON to `jevctl evaluate` on stdin.

Put the request, verified constraints, mandatory requirements, and candidate descriptions in one concise context. Candidate IDs should be short and stable. Include a `none` option when every candidate may be unsuitable.

Ask one batched `select` question for the best candidate. Define every option by when it is the simplest complete fit. Add independent `boolean` questions for requirements whose semantic satisfaction is not deterministically knowable. Do not ask the model to re-check facts that code, tests, schemas, or live data can establish exactly.

Use full detail when the decision is consequential or alternatives are close. Treat the selected option and distribution as advisory:

- reject any option that fails a mandatory deterministic requirement;
- inspect low-confidence or conflicting results yourself;
- prefer the least general option that satisfies the known case;
- do not turn uncertainty into a user question unless the missing choice materially changes the result.

The tool selects among supplied candidates. It does not authorize implementation or external actions.
