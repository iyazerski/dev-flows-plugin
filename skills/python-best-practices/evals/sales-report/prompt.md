---
tags: [python-best-practices]
max_turns: 30
timeout_seconds: 900
allowed_tools: [Read, Glob, Grep, Skill, Write, Edit, Bash]
---

I need a small Python tool that builds our monthly sales report. Inputs:

- `orders.csv`: about 30 GB, columns `order_id,customer_id,created_at,amount,currency,status,channel,notes`. `created_at` is an ISO 8601 UTC timestamp, `amount` is a decimal in the order's currency.
- `rates.csv`: daily rates, one row per date and currency, columns `date,currency,usd_rate` (multiply an amount by `usd_rate` to get USD).

Output: a Parquet file with one row per customer and month (`customer_id, month, orders, total_usd`), counting only orders with status `paid`, with `total_usd` rounded to cents, sorted by customer and month. If an order has no rate for its day and currency, the run must fail and say which ones are missing. It runs on a laptop with 16 GB of RAM.

Set up a uv project in the current directory with a command-line entry point that takes the two input paths and the output path, and add tests. uv and Python 3.14 are installed.
