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
```
Name                                  ips        average  deviation         median         99th %
pg_insert                         1292.22        0.77 ms    ±56.17%        0.65 ms        2.15 ms
db2_insert_with_erlang_odbc        353.52        2.83 ms    ±34.14%        2.66 ms        5.90 ms
db2_insert_with_rust_nif           137.09        7.29 ms    ±44.70%        7.08 ms       12.01 ms
db2wrapper::db2::insert()          133

db2wrapper::db2::insert() was called 133 times in one second.
```


## Select

```
Name                                  ips        average  deviation         median         99th %
pg_select                          6610      151.22 μs    ±28.08%      142.97 μs      264.31 μs
db2_select_with_erlang_odbc        6470      154.59 μs    ±16.21%      147.14 μs      265.57 μs
db2_select_with_rust_nif            330      3039.26 μs    ±32.66%     2717.95 μs     7850.72 μs
db2wrapper::db2::select()           290

db2wrapper::db2::select() was called 290 times in one second.
```

# Conclusion

We did benchmark postgres driver and db2 driver.

Here are the scenarios for insert operations:
1. scenario 1 [pg_insert]: create row in postgres via postgrex library
2. scenario 2 [db2_insert_with_erlang_odbc]: create row in db2 via odbc app in erlang/otp
3. scenario 3 [db2_insert_with_rust_nif]: create row in db2 via db2 driver written in rust, called from elixir using NIF
4. scenario 4 [db2wrapper::db2::insert()]: create row in db2 via db2 driver written in rust directly

From the benchmark the order from fastest to slowest are scenario 1, then scenario 2, scenario 3 then scenario 4.

After some investigation, scenario 1 is fastest because postgrex is erlang application (https://www.erlang.org/docs/17/man/application), not just code so when we call it from particular process the instruction will run on another process which started by postgrex supervisor, and they also implements some advanced methods including pooling (see DBConnection.ConnectionPool), and cursor.

Scenario 2, inserting db2 via `odbc` package. `odbc` is also erlang application, they use gen_tcp under the hood which is good. But the implementation is very simple.

Scenario 3, inserting db2 via Rust with NIF. It is pretty slow, likely because there are too many steps: erlang app to rust to db2 driver. Also there is some overhead to (de)serialize data between erlang and rust, see "Foreign Function Interface" doc for more detail. This option will be dropped.

Scenario 4, same as scenario 3.

-----------

As we know `odbc` app on scenario 2 implementation is very simple. I'm thinking that we can create new library based on `odbc` application. First, we learn how db2 client work in other language. After gaining a knowledge by reading db2 client codebase we can implement our own db2 driver with more confident. Then, this new library can head to head again with postgrex.
