---
name: harden
description: Review a codebase, fix the real findings on a branch, and merge a peer-reviewed PR. Use when the user asks to harden, or review and fix, code.
---

# Harden

1. **Review.** Use the focus areas the user gives. If none, review against the language's best practices, and look at structure, performance, and implicit state machines. Get a $second-opinion.
2. **Filter.** Keep only findings that are real and likely to happen. Drop rare edge cases, theory, and fixes that cost more than they give. Small, harmless implicit state can stay.
3. **Report and wait.** Explain each finding in simple words: what breaks, when, and why it matters. Propose a fix order in chunks. Wait for approval.
4. **Fix.** Create a branch from the updated default branch. Fix one chunk at a time, and $commit each chunk.
5. **PR.** $draft-pr and mark it ready. Get the peer's review of the PR diff and fix the real findings. When CI passes, merge it.
6. **Wrap up.** Explain in simple words what changed for users, for developers, and for performance, and be honest about what you didn't measure. List what you left out.
