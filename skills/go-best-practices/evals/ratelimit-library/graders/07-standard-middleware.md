---
type: llm
focus: trace
weight: 1
---

The middleware has the shape func(http.Handler) http.Handler, keys on the host from net.SplitHostPort(r.RemoteAddr), does not trust X-Forwarded-For without an explicit option, and sets Retry-After on 429
