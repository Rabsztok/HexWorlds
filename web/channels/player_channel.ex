require IEx

defmodule Game.PlayerChannel do
  use Phoenix.Channel

  alias Game.Tile

  def join("player:lobby", _message, socket) do
    tiles = Tile.Queries.within_range(%{x: 0, y: 0, z: 0}, 30)
    {:ok, %{tiles: tiles}, socket}
  end
end