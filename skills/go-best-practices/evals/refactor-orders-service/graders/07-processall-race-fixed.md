---
type: llm
focus: trace
weight: 1
---

The concurrent append to the shared error slice in ProcessAll is fixed with a mutex, a channel, or per-index results
