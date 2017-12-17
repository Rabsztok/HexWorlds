defmodule GameWeb.TileChannel do
	use Phoenix.Channel
	require Logger

  alias Game.Tile

  def join("tiles:lobby", %{"world_id" => world_id}, socket) do
    tiles = Tile.Queries.within_range(world_id, %{x: 0, y: 0, z: 0}, 50)
    {:ok, %{tiles: tiles}, socket}
  end


  def handle_in("move", %{"world_id" => world_id, "coordinates" => coordinates, "range" => range}, socket) do
    coordinates = Map.new(coordinates, fn {k, v} -> {String.to_atom(k), v} end)
    tiles = Tile.Queries.within_range(world_id, coordinates, range)
    broadcast! socket, "move", %{tiles: tiles}
    {:noreply, socket}
  end
end