---
name: deslop
description: Radically reduce comments, low-value tests, speculative defensive code, and borrow-checker workarounds. Use when the user asks to de-slop code or cut boilerplate.
---

# Deslop

Make the cleanup directly within the requested scope. Aim for a radical reduction in unnecessary code, not cosmetic edits or a deletion quota. This is not a general hardening or refactoring pass.

1. **Review**:
   - **Comments.** Keep only comments required by the language or tooling, legal notices, and short explanations of non-obvious behavior or constraints. Delete narration, repeated signatures, obvious documentation, and stale notes.
   - **Tests.** Keep a small set of meaningful tests for production behavior and real regressions. Delete redundant, trivial, implementation-detail, and coverage-only tests. Remove tests for non-production features and paths, including internal-only scripts and utilities. Judge this by what the code does, not its directory: a production data migration is a production path. Merge similar tests when they share setup and behavior. Remove orphaned fixtures and test-only dependencies. Don't add replacement tests just to retain coverage.
   - **Defensive code.** Delete impossible checks, speculative safeguards, silent fallbacks, obsolete compatibility paths, and costly handling for extremely rare cases. Verify assumptions against actual callers, types, schemas, data, and decision history. Don't keep speculative handling just because it exists. Keep protections for real security, I/O, concurrency, and data-integrity risks. Fail clearly for unsupported cases rather than pretending success.
   - **Borrow-checker workarounds.** In Rust, remove unnecessary clones, intermediate collections, dummy state, and indirection introduced only to work around borrowing. Prefer moves, shorter borrows, disjoint fields, and behavior on the owning type. Leverage ownership and the compiler's guarantees. Don't remove copies needed by actual callers or replace safe code with `unsafe`, unchecked operations, or runtime borrow checks just to shorten it.

   Review the full requested scope across all four areas, not just obvious lint fixes.
2. **Remove.** Create a branch from the updated default branch. Apply verified cuts in small, coherent edits. Prefer deletion and existing helpers over replacement scaffolding or new abstractions. Remove one chunk at a time, and $commit each chunk.
3. **PR.** $draft-pr and mark it ready. When CI passes, merge it.
4. **Release.** Find out how this repo releases: recent release commits and tags, a changelog, release scripts, or CI workflows. Follow the same process for the merged changes, for example bumping the version or pushing a tag. If merging to the default branch already is the release, do nothing.
5. **Wrap up.** Summarize what was removed, which meaningful tests and protections remain, checks run, and rare cases deliberately left unsupported.
