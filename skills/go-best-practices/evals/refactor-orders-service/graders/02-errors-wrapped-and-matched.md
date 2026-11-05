---
type: llm
focus: trace
weight: 1
---

Errors are wrapped with %w where context is added, and callers match them with errors.Is or errors.As instead of ==
