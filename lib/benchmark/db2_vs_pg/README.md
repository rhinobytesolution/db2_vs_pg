# Benchmarks

## How to run

```bash
# go to container
make console_gen_game
# run the benchmark
mix run lib/benchmark/db2_vs_pg/benchmark_start.exs
```

# Benchmark Detail

# Results

## Insert

Name                                  ips        average  deviation         median         99th %
pg_insert                         1292.22        0.77 ms    ±56.17%        0.65 ms        2.15 ms
db2_insert_with_erlang_odbc        353.52        2.83 ms    ±34.14%        2.66 ms        5.90 ms
db2_insert_with_rust_nif           137.09        7.29 ms    ±44.70%        7.08 ms       12.01 ms
db2wrapper::db2::insert()          133

db2wrapper::db2::insert() was called 133 times in one second.

## Select

Name                                  ips        average  deviation         median         99th %
pg_select                          6610      151.22 μs    ±28.08%      142.97 μs      264.31 μs
db2_select_with_erlang_odbc        6470      154.59 μs    ±16.21%      147.14 μs      265.57 μs
db2_select_with_rust_nif            330      3039.26 μs    ±32.66%     2717.95 μs     7850.72 μs
db2wrapper::db2::select()           290

db2wrapper::db2::select() was called 290 times in one second.

[TODO]

## Additional notes


benchmark pg default

PGPASSWORD=postgres pgbench -U postgres -h localhost -p 5433 -i -s 100 example
