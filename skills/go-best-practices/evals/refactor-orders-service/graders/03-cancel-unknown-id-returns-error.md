---
type: llm
focus: trace
weight: 1
---

Cancel returns an error for an unknown order ID instead of dereferencing a nil order, and the error matches ErrNotFound with errors.Is
