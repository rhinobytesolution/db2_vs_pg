# Benchmarks

## How to run

```bash
# go to container
make console_gen_game
# run the benchmark
mix run lib/benchmark/db2_vs_pg/benchmark_start.exs
```

# Benchmark Detail

# Example results

**Postgres**


![pg](./docs/benchmark_pg.png)

**DB2**

[TODO]

## Additional notes


benchmark pg default

PGPASSWORD=postgres pgbench -U postgres -h localhost -p 5433 -i -s 100 example
