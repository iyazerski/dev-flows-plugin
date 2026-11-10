---
name: harden
description: Review a codebase, fix the real findings on a branch, and merge a peer-reviewed PR. Use when the user asks to harden, or review and fix, code.
---

# Harden

1. **Review.** Use the focus areas the user gives. If none, review:
   - alignment with the language's best practices;
   - code structure;
   - performance;
   - implicit state machines;
   - custom logic that a library could replace: prefer the standard library or an existing dependency, adapting to its interface. Suggest a new, well-maintained library when it fits and removes real custom code.

   Get a $second-opinion.
2. **Filter.** Keep only findings that are real and likely to happen. Drop rare edge cases, theory, and fixes that cost more than they give. Small, harmless implicit state can stay.
3. **Report and wait.** Explain each finding in simple words: what breaks, when, and why it matters. Propose a fix order in chunks. Wait for approval.
4. **Fix.** Create a branch from the updated default branch. Fix one chunk at a time, and $commit each chunk.
5. **PR.** $draft-pr and mark it ready. Get the peer's review of the PR diff and fix the real findings. When CI passes, merge it.
6. **Release.** Find out how this repo releases: recent release commits and tags, a changelog, release scripts, or CI workflows. Follow the same process for the merged changes, for example bumping the version or pushing a tag. If merging to the default branch already is the release, do nothing.
7. **Wrap up.** Explain in simple words what changed for users, for developers, and for performance, and be honest about what you didn't measure. List what you left out.
