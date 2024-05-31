defmodule Benchmark.Db2VsPg.Db2 do
  use Agent

  @setup_sql [
    "drop table players",
    ~s"create table PUBLIC.players
    (
        id       int generated always as identity,
        username varchar(128),
        pos_x    int,
        pos_y    int
    )",
    "create unique index PLAYERS_ID_UINDEX on PUBLIC.players (id)"
  ]

  def start_link() do
    Agent.start_link(fn -> %{conn: nil, counter: 0} end, name: __MODULE__)
  end

  def setup() do
    set_conn()
    %{conn: conn} = Agent.get(__MODULE__, & &1)

    migrate(conn)
    truncate(conn)
    :ok
  end

  def select(conn) do
    {:selected, _, _} = :odbc.sql_query(conn, to_charlist("SELECT * FROM PUBLIC.players LIMIT 1"))
  end

  def insert(conn) do
    %{counter: counter} = Agent.get(__MODULE__, & &1)
    Agent.update(__MODULE__, &Map.put(&1, :counter, counter + 1))

    sql =
      "INSERT INTO PUBLIC.players (username, pos_x, pos_y) VALUES ('#{counter}', '#{counter}', '#{counter}')"

    :odbc.sql_query(conn, to_charlist(sql))
  end

  defp truncate(conn) do
    :odbc.sql_query(conn, to_charlist("truncate PUBLIC.PLAYERS IMMEDIATE"))
  end

  defp set_conn() do
    conn_str = System.get_env("DB2_CONNECTION_STRING") |> to_charlist()
    {:ok, conn} = :odbc.connect(conn_str, binary_strings: :on)

    Agent.update(__MODULE__, &Map.put(&1, :conn, conn))
  end

  defp migrate(conn) do
    Enum.each(@setup_sql, fn sql -> :odbc.sql_query(conn, to_charlist(sql)) end)
  end
end
