defmodule Benchmark.Db2VsPg.Benchmark do
  alias Benchmark.Db2VsPg.Pg
  alias Benchmark.Db2VsPg.Db2

  def start_benchmark() do
    %{conn: conn} = Pg.get_state()

    Benchee.run(%{
      "pg_insert_ops" => fn -> Pg.insert(conn) end,
      "db2_insert_ops" => fn -> Db2.insert(conn) end,
      "pg_select_ops" => fn -> Pg.select(conn) end,
      "db2_select_ops" => fn -> Db2.select(conn) end
    })
  end
end
