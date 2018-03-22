defmodule GameWeb.TileController do
  use GameWeb, :controller

  alias Game.Tile

  def index(conn, %{"world_id" => world_id, "coordinates" => coordinates, "range" => range}) do
    {range, _} = Integer.parse(range)
    coordinates = Map.new(coordinates, fn {k, v} ->
      {value, _} = Integer.parse(v)
      {String.to_atom(k), value}
    end)

    tiles = Tile.Queries.within_range(
      world_id,
      { coordinates.x, coordinates.y, coordinates.z },
      range
    )

    render(conn, "index.json", tiles: tiles)
  end

  def index(conn, %{"world_id" => world_id}) do
    tiles = Repo.all(
      from tile in Tile,
      where: tile.world_id == ^world_id
    )

    render(conn, "index.json", tiles: tiles)
  end
end
