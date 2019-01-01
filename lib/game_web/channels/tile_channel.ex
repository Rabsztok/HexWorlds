defmodule GameWeb.TileChannel do
  use Phoenix.Channel
  require Logger

  import Ecto.Query
  alias Game.Tile

  def join("tiles:lobby", %{"region_id" => region_id}, socket) do
    send(self(), {:after_join, region_id})

    {:ok, %{}, socket}
  end

  def join("tiles:" <> region_id, _message, socket) do
    send(self(), {:after_join, region_id})

    {:ok, %{}, socket}
  end

  def handle_info({:after_join, region_id}, socket) do
    tiles = Game.Repo.all(from(tile in Tile, where: tile.region_id == ^region_id))
    push(socket, "load", %{tiles: tiles})
    {:noreply, socket}
  end
end
