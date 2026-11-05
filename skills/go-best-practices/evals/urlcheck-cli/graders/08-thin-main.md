---
type: llm
focus: trace
weight: 1
---

main only calls a run function that returns an error (or exit code), and os.Exit is called only from main
