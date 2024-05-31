defmodule Benchmark.Db2VsPg.Pg do
  @moduledoc """

  # benchmark manual
  Benchmark.Db2VsPg.Pg.start_link()
  Benchmark.Db2VsPg.Pg.init()
  %{conn: conn} = Agent.get(Benchmark.Db2VsPg.Pg, & &1)

  """
  use Agent

  @setup_sql [
    "drop table players",
    ~s"
    create table players
    (
        id       serial
            constraint players_pk
                primary key,
        username varchar(128),
        pos_x    int,
        pos_y    int
    )",
    "create unique index players_id_uindex on players (id)",
    "create unique index players_username_uindex on players (username)"
  ]

  def start_link() do
    Agent.start_link(fn -> %{conn: nil, counter: 0} end, name: __MODULE__)
  end

  def setup() do
    conn = set_conn()

    migrate(conn)
    truncate(conn)
    conn
  end

  def get_state() do
    Agent.get(__MODULE__, & &1)
  end

  def select(conn) do
    {:ok, %Postgrex.Result{}} = Postgrex.query(conn, "SELECT * FROM players LIMIT 1", [])
  end

  def insert(conn) do
    %{counter: counter} = Agent.get(__MODULE__, & &1)
    Agent.update(__MODULE__, &Map.put(&1, :counter, counter + 1))

    sql =
      "INSERT INTO players (username, pos_x, pos_y) VALUES ('#{counter}', '#{counter}', '#{counter}')"

    {:ok, %Postgrex.Result{command: :insert}} = Postgrex.query(conn, sql, [])
  end

  def count(conn) do
    {:ok, %Postgrex.Result{rows: rows}} = Postgrex.query(conn, "SELECT count(*) FROM players", [])

    rows
    |> List.first()
    |> List.first()
  end

  defp truncate(conn) do
    Postgrex.query(conn, "TRUNCATE players", [])
  end

  defp set_conn() do
    {:ok, conn} =
      Postgrex.start_link(
        hostname: System.get_env("PG_HOSTNAME"),
        port: System.get_env("PG_PORT"),
        username: System.get_env("PG_USERNAME"),
        password: System.get_env("PG_PASSWORD"),
        database: System.get_env("PG_DATABASE")
      )

    Agent.update(__MODULE__, &Map.put(&1, :conn, conn))
    conn
  end

  defp migrate(conn) do
    Enum.each(@setup_sql, fn sql -> Postgrex.query(conn, sql, []) end)
  end
end
