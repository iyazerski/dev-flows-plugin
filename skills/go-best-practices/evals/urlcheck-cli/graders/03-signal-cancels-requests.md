---
type: llm
focus: trace
weight: 1
---

Ctrl-C cancels in-flight requests: the program uses signal.NotifyContext (or equivalent) and passes the context to http.NewRequestWithContext
