---
type: llm
focus: trace
weight: 1
---

Idle keys are evicted either lazily during calls or by a background goroutine that a Close or Stop method (or a context) can end; no goroutine is started that can never stop
