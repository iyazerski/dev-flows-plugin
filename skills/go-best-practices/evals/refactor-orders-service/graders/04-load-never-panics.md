---
type: llm
focus: trace
weight: 1
---

LoadFromFile never panics on a missing file or malformed JSON: it returns errors that name the file, and it checks the json and Save errors
