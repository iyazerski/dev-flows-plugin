---
type: llm
focus: trace
weight: 1
---

No goroutine can block forever when the run is cancelled: sends are guarded by ctx.Done() or go to a buffered channel sized for every result, and channels are closed by their sender
