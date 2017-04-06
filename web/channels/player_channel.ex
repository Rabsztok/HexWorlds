require IEx

defmodule Game.PlayerChannel do
  use Phoenix.Channel

  alias Game.Tile

  def join("player:lobby", _message, socket) do
    tiles = Tile.Queries.within_range(%{q: 0, r: 0}, 10)
    {:ok, %{tiles: tiles}, socket}
  end
end