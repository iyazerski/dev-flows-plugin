---
name: deslop
description: Remove unnecessary comments, tests, defensive code, and ownership workarounds. Use when the user asks to de-slop code or cut boilerplate.
---

# Deslop

1. **Review.** Use the user's focus areas. If none, review:
   - comments that repeat the code: keep required notices, tool-consumed text, and explanations of non-obvious behavior;
   - duplicate, trivial, and coverage-only tests, plus tests for internal utilities outside production paths: keep meaningful production regressions and merge similar cases;
   - impossible checks, speculative safeguards, silent fallbacks, and obsolete compatibility paths;
   - ownership workarounds: prefer moves, shorter borrows, and disjoint fields over unnecessary clones, collections, or dummy state. Trust the language's guarantees.

   Get a $second-opinion.
2. **Filter.** Verify assumptions against callers, types, schemas, and history. Remove only what is genuinely unnecessary. Keep real security, I/O, concurrency, and lifecycle protections. Don't replace safe code with unsafe shortcuts or bigger abstractions.
3. **Report and wait.** Explain the worthwhile cuts and what stays. Propose chunks and wait for approval unless implementation is already authorized.
4. **Simplify.** Work on a branch, preserving existing changes. Delete rather than add replacement scaffolding. Keep behavior in its owning module. Don't target a line count or coverage score.
5. **Verify.** Run the relevant tests, hooks, lint, and type checks. Check for accidental behavior changes. Measure hot-path changes rather than guessing.
6. **Ship.** Only when authorized, $commit the chunks, $draft-pr, get the peer's review, and merge after CI passes. Follow the repo's normal release process without duplicating automatic releases.
7. **Wrap up.** Summarize what was removed, what safeguards remain, checks run, and anything left out or unmeasured.
