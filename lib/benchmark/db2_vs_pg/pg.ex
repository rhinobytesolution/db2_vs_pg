defmodule Benchmark.Db2VsPg.Pg do
  @moduledoc """

  # benchmark manual
  Benchmark.Db2VsPg.Pg.start_link()
  Benchmark.Db2VsPg.Pg.init()
  %{conn: conn} = Agent.get(Benchmark.Db2VsPg.Pg, & &1)

  """
  use Agent

  def start_link() do
    Agent.start_link(fn -> %{conn: nil, counter: 0} end, name: __MODULE__)
  end

  def init() do
    _url = "DATABASE_URL=ecto://postgres:postgres@localhost:5432/gen_game_dev"

    url_chunk =
      System.get_env("DATABASE_URL")
      |> String.split(":")
      |> Enum.map(fn v -> String.split(v, "@") end)
      |> List.flatten()
      |> Enum.map(fn v -> String.split(v, "/") end)
      |> List.flatten()

    {:ok, conn} =
      Postgrex.start_link(
        hostname: Enum.at(url_chunk, 5),
        port: Enum.at(url_chunk, 6),
        username: Enum.at(url_chunk, 3),
        password: Enum.at(url_chunk, 4),
        database: Enum.at(url_chunk, 7)
      )

    truncate(conn)

    Agent.update(__MODULE__, &Map.put(&1, :conn, conn))
  end

  def get_state() do
    Agent.get(__MODULE__, & &1)
  end

  def select(conn) do
    {:ok, %Postgrex.Result{}} = Postgrex.query(conn, "SELECT * FROM accounts LIMIT 1", [])
  end

  def insert(conn) do
    %{counter: counter} = Agent.get(__MODULE__, & &1)
    Agent.update(__MODULE__, &Map.put(&1, :counter, counter + 1))

    {:ok,
     %Postgrex.Result{
       command: :insert
     }} =
      Postgrex.query(
        conn,
        "INSERT INTO accounts (username, inserted_at, updated_at) VALUES (gen_random_uuid(), '2024-05-29 12:26:15', '2024-05-29 12:26:15')",
        []
      )
  end

  defp truncate(conn) do
    Postgrex.query(conn, "TRUNCATE accounts", [])
  end
end
