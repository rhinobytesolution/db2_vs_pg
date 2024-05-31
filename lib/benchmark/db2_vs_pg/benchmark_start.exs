alias Benchmark.Db2VsPg.Pg
alias Benchmark.Db2VsPg.Db2
alias Benchmark.Db2VsPg.Benchmark

Pg.start_link()
:ok = Pg.setup()

Db2.start_link()
:ok = Db2.setup()

Benchmark.start_benchmark()
