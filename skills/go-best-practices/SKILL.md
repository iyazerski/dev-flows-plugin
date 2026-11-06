---
name: go-best-practices
description: >-
  Go rules that linters can't enforce: new Go 1.27 standard library features and subtle
  pitfalls in interfaces, errors, concurrency, I/O, transactions, and tests. Use when
  writing, reviewing, refactoring, or debugging Go code (.go files or go.mod).
---

# Go best practices

This file assumes Go 1.27 or newer, and that the repo's hooks run `gofmt`, `go fix`,
`golangci-lint`, and `go test -race`. It lists only what those tools don't catch. If the
repo has no Go hooks, suggest that the user adopt `assets/pre-commit-config.yaml` and
`assets/golangci.yml`.

## Tools

- Fix a lint instead of silencing it. If a lint is wrong for one line, use
  `//nolint:name // reason` on that line.
- When the `gopls` MCP tools are available, prefer them to text search: `go_search` to
  find symbols, `go_symbol_references` before you change a definition, `go_rename_symbol`
  for renames, and `go_diagnostics` on edited files.
- When unsure whether a standard library symbol exists, run `go doc pkg.Symbol`.

## Newer than your training data

- `uuid` (`uuid.New`, `uuid.NewV7`, `uuid.Parse`) is in the standard library. Don't add
  `github.com/google/uuid`.
- Methods can have their own type parameters. Use them instead of package-level generic
  helpers that serve one type.
- `encoding/json/v2` and `encoding/json/jsontext` are stable. Prefer v2 in new code.
  Switching an existing import changes behavior with no compile error: names match
  case-sensitively, duplicate names and invalid UTF-8 fail, nil slices and maps encode
  as `[]` and `{}`, and `time.Duration` has no default encoding. Keep old wire formats
  with v1's `json.DefaultOptionsV1()` or single options like `FormatDurationAsNano(true)`.
- `os.Root` confines file access to a directory. Use it for untrusted names instead of
  `filepath.Join` plus prefix checks.
- `tool` directives in `go.mod` (`go get -tool`) replace `tools.go` files.
- Write benchmarks with `for b.Loop()`. `go fix` doesn't convert `b.N` loops.
- `GOMAXPROCS` follows container CPU limits on its own. Don't add `automaxprocs`.

## Design

- Define an interface in the package that uses it, with only the methods that package
  calls. Constructors return concrete types.
- `slices.Clone` and `maps.Clone` are shallow. When a stored or returned value must not
  share memory with the caller, copy nested slices, maps, and pointers too.
- A small substring or subslice keeps its whole backing array alive. Copy it with
  `strings.Clone` or `slices.Clone` before storing it long-term.

## Errors and I/O

- The lint config allows unchecked `Close` and `Flush`, because that's fine for readers.
  For writers, check both: return the error, or `errors.Join` it with the write error.
- `bufio.Scanner` fails with `bufio.ErrTooLong` on lines over 64 KiB. Call `sc.Buffer`
  when lines can be longer, and always check `sc.Err()`.
- `json.Decoder.Decode` reads one value and ignores what follows. When the input must be
  a single document, check that the next `Decode` returns `io.EOF`, or use
  `json.Unmarshal` or v2's `UnmarshalRead`, which reject trailing data.
- HTTP handlers shouldn't send internal error text to clients. Log it and return a status
  with a short message.

## Concurrency and context

- Every goroutine needs an owner that stops it and waits for it to exit before shutdown
  completes. Stopping without waiting still leaks work.
- `select` picks randomly among ready cases, so `ctx.Done()` has no priority. Check
  `ctx.Err()` before starting each unit of work in a loop.
- With `SetLimit`, `errgroup.Group.Go` blocks until a slot is free and ignores the
  context. Check `ctx.Err()` before calling it, or use `TryGo`.
- `context.WithoutCancel` drops the deadline too. Detached work needs its own timeout and
  an owner that waits for it.
- `http.Client.Timeout` covers reading the whole body, so it cuts off streaming and long
  downloads. Use per-request context deadlines there.
- `MaxIdleConnsPerHost` defaults to 2. It doesn't cap concurrency, but extra connections
  are closed instead of reused. Raise it when many concurrent requests go to one host.
- Inside a transaction, every query must use `tx`, not `db`. A stray `db` call runs
  outside the transaction and can deadlock when the pool is small. `Rollback` after
  `Commit` returns `sql.ErrTxDone`, so a deferred `Rollback` can ignore it.
- `GOMEMLIMIT` is a soft target for the Go heap, not a hard cap. Leave headroom for
  memory outside the Go heap (cgo, mapped files) below the container limit.

## Tests

- In `testing/synctest`, time advances only when every goroutine in the bubble is
  durably blocked. Network I/O and mutexes don't count, so use `net.Pipe` instead of real
  sockets inside a bubble.
