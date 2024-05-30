# Benchmarks

## PG

```
# go to container
make console_gen_game
# run the benchmark
mix run lib/benchmark/db2_vs_pg/benchmark_start.exs
```

## Benchmark Detail

```sql
INSERT INTO accounts (username, inserted_at, updated_at) VALUES (gen_random_uuid(), '2024-05-29 12:26:15', '2024-05-29 12:26:15')
```

# Example results

PG

![pg](./docs/benchmark_pg.png)

## Additional notes


benchmark pg default

PGPASSWORD=postgres pgbench -U postgres -h localhost -p 5433 -i -s 100 example
