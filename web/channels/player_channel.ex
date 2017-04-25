require IEx

defmodule Game.PlayerChannel do
  use Phoenix.Channel

  alias Game.Tile

  def join("player:lobby", _message, socket) do
    tiles = Tile.Queries.within_range(%{x: 0, y: 0, z: 0}, 2)
    {:ok, %{tiles: tiles}, socket}
  end

  def handle_in("move", %{"coordinates" => coordinates, "range" => range}, socket) do
    coordinates = Map.new(coordinates, fn {k, v} -> {String.to_atom(k), v} end)
    tiles = Tile.Queries.within_range(coordinates, range)
    broadcast! socket, "move", %{tiles: tiles}
    {:noreply, socket}
  end
end