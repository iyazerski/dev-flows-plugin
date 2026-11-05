---
tags: [go-best-practices]
max_turns: 30
timeout_seconds: 900
allowed_tools: [Read, Glob, Grep, Skill, Write, Edit, Bash]
---

Write me a Go CLI called `urlcheck`. It reads URLs from a file (one per line, blank lines and `#` comments ignored) and checks them concurrently with an HTTP GET. Flags: `-c` for max concurrent requests (default 8) and `-timeout` per request (default 5s). Print one line per URL with the status code or the error, sorted by URL, then a summary line. Exit with status 1 if any URL failed (non-2xx or error). Ctrl-C should stop the run quickly. Standard library only, Go 1.27 is installed. Set up the module in the current directory with a main package and tests.
