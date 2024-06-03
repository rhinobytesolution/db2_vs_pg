defmodule Benchmark.Db2VsPg.PgWorker do
  @moduledoc """
  try:

  {:ok, pid} = DynamicSupervisor.start_child(
    {:via, PartitionSupervisor, {GenGame.Benchmark.DynamicSupervisor, self()}},
    {Benchmark.Db2VsPg.PgWorker, %{}}
  )
  Benchmark.Db2VsPg.PgWorker.insert()
  """

  use GenServer

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def insert() do
    server = {:via, PartitionSupervisor, {GenGame.Benchmark.DynamicSupervisor, self()}}
    GenServer.call(server, :insert)
  end

  @impl true
  def init(_) do
    {:ok, conn} = Benchmark.Db2VsPg.Pg.create_conn()
    {:ok, %{conn: conn}}
  end

  @impl true
  def handle_call(:insert, _from, %{conn: conn} = state) do
    Benchmark.Db2VsPg.Pg.insert(conn)
    {:noreply, state}
  end
end
