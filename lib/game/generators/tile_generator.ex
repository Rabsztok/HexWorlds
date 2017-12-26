defmodule Game.TileGenerator do
  import Ecto.Query
  alias Game.Repo
  alias Game.Tile
  alias Game.Region
  import Logger

  defp calculate_height({coordinates, tile}, calculated_tiles, neighbors, remaining_tiles, boundary_tiles) when map_size(neighbors) > 0  do
    calculated_and_boundary_tiles = Map.merge(boundary_tiles, calculated_tiles)
    calculated_neighbors = Game.TileMap.neighbors(calculated_and_boundary_tiles, coordinates)

    calculated_neighbors_height = Enum.reduce(calculated_neighbors, 0, fn ({_, neighbor}, sum) ->
      sum + (Map.get(neighbor, :height, 0) || 0)
    end)

    height = if map_size(calculated_neighbors) > 0 do
      round(calculated_neighbors_height / map_size(calculated_neighbors)) + :rand.uniform(5) - 3
    else
      1
    end

    tile = Map.put(tile, :height, height)
    calculated_tiles = Map.put(calculated_tiles, coordinates, tile)
    neighbors = Map.merge(neighbors, Game.TileMap.neighbors(remaining_tiles, coordinates))
    remaining_tiles = Map.drop(remaining_tiles, Map.keys(neighbors))
    {next_coordinates, next_tile} = Enum.random(neighbors)
    neighbors = Map.delete(neighbors, next_coordinates)

    Map.put(calculate_height({next_coordinates, next_tile}, calculated_tiles, neighbors, remaining_tiles, boundary_tiles), coordinates, tile)
  end

  defp calculate_height({coordinates, tile}, calculated_tiles, %{}, %{}, %{}) do
    Map.put(calculated_tiles, coordinates, tile)
  end

  def calculate_height(tiles) do
    coordinates = {0,0,0}
    {tile, remaining_tiles} = Map.pop(tiles, coordinates)
    neighbors = Game.TileMap.neighbors(remaining_tiles, coordinates)
    remaining_tiles = Map.drop(remaining_tiles, Map.keys(neighbors))

    Map.put(calculate_height({coordinates, tile}, %{}, neighbors, remaining_tiles, %{}), coordinates, tile)
  end

  defp calculate_height(tiles, boundary_tiles) do
    neighbors = Enum.reduce(tiles, %{},
      fn ({coords, tile}, acc) ->
        if map_size(Game.TileMap.neighbors(boundary_tiles, coords)) > 0 do
          Map.put(acc, coords, tile)
        else
          acc
        end
      end
    )

    remaining_tiles = Map.drop(tiles, Map.keys(neighbors))
    {next_coordinates, next_tile} = Enum.random(neighbors)
    neighbors = Map.delete(neighbors, next_coordinates)

    calculate_height({next_coordinates, next_tile}, %{}, neighbors, remaining_tiles, boundary_tiles)
  end

  defp save(tiles) do

    Repo.insert_all(
      Tile,
      tiles
    )
  end

  def call(region) do
    center = {region.x, region.y, region.z}
    tiles = Game.TileMap.generate(center)

    if center == {0,0,0} do
      tiles = calculate_height(tiles)
    else
      boundary_tiles = Tile.Queries.within_range(region.world_id, %{x: region.x, y: region.y, z: region.z}, Region.size + 1)
      boundary_tiles = Enum.reduce(boundary_tiles, %{}, fn (tile, acc) ->
        Map.put(acc, {tile.x, tile.y, tile.z}, %{x: tile.x, y: tile.y, z: tile.z, height: tile.height})
      end)
      tiles = calculate_height(tiles, boundary_tiles)
    end
    tile_values = Map.values(tiles)
    tile_values = Enum.map(tile_values, fn (tile) -> Map.put(tile, :terrain, %{ type: "dirt" }) end)
    tile_values = Enum.map(tile_values, fn (tile) -> Map.put(tile, :region_id, region.id) end)
    tile_values = Enum.map(tile_values, fn (tile) -> Map.put(tile, :world_id, region.world_id) end)
    chunked_tiles = Enum.chunk_every(tile_values, 5000)

    Enum.each(chunked_tiles, fn (chunk) -> save(chunk) end)

    region
  end
end