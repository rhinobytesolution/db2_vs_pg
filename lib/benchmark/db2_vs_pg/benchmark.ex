defmodule Benchmark.Db2VsPg.Benchmark do
  alias Benchmark.Db2VsPg.Pg

  def start_benchmark() do
    list = Enum.to_list(1..10_000)
    map_fun = fn i -> [i, i * i] end

    %{conn: conn} = Pg.get_state()

    Benchee.run(%{
      "flat_map" => fn -> Enum.flat_map(list, map_fun) end,
      "pg_insert_ops" => fn -> Pg.insert(conn) end,
      "pg_select_ops" => fn -> Pg.select(conn) end
    })
  end
end
