---
tags: [go-best-practices]
max_turns: 30
timeout_seconds: 900
allowed_tools: [Read, Glob, Grep, Skill, Write, Edit, Bash]
---

I need a small Go library package for our HTTP services: module `example.com/ratelimit`, package `ratelimit`. It should provide a per-key token bucket limiter (rate in tokens per second plus a burst size) with a non-blocking `Allow(key)` and a blocking `Wait(ctx, key)`, and an HTTP middleware that limits by client IP and responds 429 with a Retry-After header. Keys that have been idle for a while must not stay in memory forever. Write it yourself on the standard library, no `golang.org/x/time/rate`. Include tests. Go 1.27 is installed. Put everything in the current directory.
