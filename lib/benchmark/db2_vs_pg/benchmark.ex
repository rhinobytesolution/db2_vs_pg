defmodule Benchmark.Db2VsPg.Benchmark do
  alias Benchmark.Db2VsPg.Pg
  alias Benchmark.Db2VsPg.Db2

  def start_benchmark() do
    benchmark_insert()
    benchmark_select()
  end

  defp benchmark_select() do
    Benchee.run(
      %{
        "pg_select" => fn {_input, {pg_conn, _db2_conn}} -> Pg.select(pg_conn) end,
        "db2_select_with_erlang_odbc" => fn {_input, {_pg_conn, db2_conn}} ->
          Db2.select(db2_conn)
        end,
        "db2_select_with_rust_nif" => fn _ -> Db2Wrapper.select() end
      },
      before_scenario: &before_scenario/1
    )
  end

  defp benchmark_insert() do
    Benchee.run(
      %{
        "pg_insert" => fn {_input, {pg_conn, _db2_conn}} -> Pg.insert(pg_conn) end,
        "db2_insert_with_erlang_odbc" => fn {_input, {_pg_conn, db2_conn}} ->
          Db2.insert(db2_conn)
        end,
        "db2_insert_with_rust_nif" => fn _ -> Db2Wrapper.insert() end
      },
      before_scenario: &before_scenario/1
    )
  end

  defp before_scenario(input) do
    Pg.start_link()
    pg_conn = Pg.setup()

    Db2.start_link()
    db2_conn = Db2.setup()

    {input, {pg_conn, db2_conn}}
  end
end
