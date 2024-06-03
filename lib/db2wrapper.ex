defmodule Db2Wrapper do
  use Rustler, otp_app: :gen_game, crate: "db2wrapper"

  def insert(), do: :erlang.nif_error(:nif_not_loaded)
  def select(), do: :erlang.nif_error(:nif_not_loaded)
end
