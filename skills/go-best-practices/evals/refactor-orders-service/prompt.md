---
tags: [go-best-practices]
max_turns: 30
timeout_seconds: 900
allowed_tools: [Read, Glob, Grep, Skill, Write, Edit, Bash]
---

Here is our orders package. A contractor wrote it and it works, but reviews keep flagging it. Can you refactor it into idiomatic Go and give me a short list of what you changed and why? Keep the behavior the same, and update the tests if a signature changes. Write the change list as CHANGES.md in the current directory.

Input files: go.mod, orders.go, orders_test.go
