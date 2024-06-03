defmodule Benchmark.Db2VsPg.Benchmark do
  alias Benchmark.Db2VsPg.Pg
  alias Benchmark.Db2VsPg.Db2

  def start_benchmark() do
    benchmark_select()
    benchmark_insert()
  end

  defp benchmark_select() do
    Benchee.run(
      %{
        "pg_select_ops" => fn {_input, {pg_conn, _db2_conn}} -> Pg.select(pg_conn) end,
        "db2_select_ops" => fn {_input, {_pg_conn, db2_conn}} -> Db2.select(db2_conn) end
      },
      before_scenario: &before_scenario/1
    )
  end

  defp benchmark_insert() do
    Benchee.run(
      %{
        "pg_insert_ops" => {
          fn {_input, {pg_conn, _db2_conn}} -> Pg.insert(pg_conn) end,
          after_scenario: fn {_input, {pg_conn, _db2_conn}} ->
            pg2_count = Pg.count(pg_conn)

            IO.puts("count rows pg: #{pg2_count}")
          end
        },
        "pg_insert_ops" => {
          fn {_input, {pg_conn, _db2_conn}} -> Pg.insert(pg_conn) end
          # after_scenario: fn {_input, {pg_conn, _db2_conn}} ->
          #   pg2_count = Pg.count(pg_conn)

          #   IO.puts("count rows pg: #{pg2_count}")
          # end
        },
        "db2_insert_ops" => {
          fn {_input, {_pg_conn, db2_conn}} -> Db2.insert(db2_conn) end
          # after_scenario: fn {_input, {_pg_conn, db2_conn}} ->
          #   db2_count = Db2.count(db2_conn)

          #   IO.puts("count rows db2: #{db2_count}")
          # end
        }
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
