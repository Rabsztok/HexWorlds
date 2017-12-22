defmodule Game.LandmassGenerator do
  import Ecto.Query
  alias Game.Repo
  alias Game.Tile
  import Logger

  defp calculate_height({coordinates, tile}, calculated_tiles, neighbors, remaining_tiles) when map_size(neighbors) > 0  do
    calculated_neighbors = Game.TileMap.neighbors(calculated_tiles, coordinates)

    calculated_neighbors_height = Enum.reduce(calculated_neighbors, 0, fn ({_, neighbor}, sum) ->
      sum + Map.get(neighbor, :height, 0)
    end)

    height = if map_size(calculated_neighbors) > 0 do
      round(calculated_neighbors_height / map_size(calculated_neighbors)) + :crypto.rand_uniform(-2, 3)
    else
      10
    end

    tile = Map.put(tile, :height, height)
    calculated_tiles = Map.put(calculated_tiles, coordinates, tile)
    neighbors = Map.merge(neighbors, Game.TileMap.neighbors(remaining_tiles, coordinates))
    remaining_tiles = Map.drop(remaining_tiles, Map.keys(neighbors))
    {next_coordinates, next_tile} = Enum.random(neighbors)
    neighbors = Map.delete(neighbors, next_coordinates)

    Map.put(calculate_height({next_coordinates, next_tile}, calculated_tiles, neighbors, remaining_tiles), coordinates, tile)
  end

  defp calculate_height({coordinates, tile}, calculated_tiles, %{}, %{}) do
    calculated_tiles
  end

  def calculate_height(tiles) do
    coordinates = {0,0,0}
    {tile, remaining_tiles} = Map.pop(tiles, coordinates)
    neighbors = Game.TileMap.neighbors(remaining_tiles, coordinates)
    remaining_tiles = Map.drop(remaining_tiles, Map.keys(neighbors))

    Map.put(calculate_height({coordinates, tile}, %{}, neighbors, remaining_tiles), coordinates, tile)
  end

  defp save(tiles) do
    Repo.insert_all(
      Tile,
      tiles,
      on_conflict: :nothing
    )
  end

  def call(world, size) do
    tiles = Game.TileMap.generate(size)
    tiles = calculate_height(tiles)
    tiles = Map.values(tiles)
    tiles = Enum.map(tiles, fn (tile) -> Map.put(tile, :world_id, world.id) end)
    chunked_tiles = Enum.chunk_every(tiles, 5000)

    Enum.map(chunked_tiles, fn (chunk) -> save(chunk) end)
  end
end