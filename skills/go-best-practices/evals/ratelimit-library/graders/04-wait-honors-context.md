---
type: llm
focus: trace
weight: 1
---

Wait returns promptly with an error wrapping or equal to ctx.Err() when the context is cancelled, and uses a timer with select rather than time.Sleep
