---
type: llm
focus: trace
weight: 1
---

Each request has a timeout via context.WithTimeout or http.Client.Timeout; the code never uses http.Get or http.DefaultClient without a timeout
