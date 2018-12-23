defmodule TileUtils do
  defp spread({coordinates, tile}, processed_tiles, edges, remaining_tiles, size, lambda) do
    {response, tile} = lambda.(tile, processed_tiles, size)

    processed_tiles = [tile | processed_tiles]

    edges =
      if response == :ok do
        Map.values(Game.TileMap.neighbors(remaining_tiles, coordinates)) ++ edges
      else
        edges
      end

    if length(edges) > 0 do
      next_tile = Enum.random(edges)
      next_coordinates = coordinates(next_tile)
      remaining_tiles = Map.delete(remaining_tiles, next_coordinates)
      edges = Enum.reject(edges, fn edge -> edge == next_tile end)

      [
        tile
        | spread(
            {next_coordinates, next_tile},
            processed_tiles,
            edges,
            remaining_tiles,
            size,
            lambda
          )
      ]
    else
      %{}
    end
  end

  @doc """
    Spreads `lambda` calculation over random area of `size` tiles, with center in `center`
  """
  def spread(tiles, center, size, lambda) do
    # We use size as a range, because we should get ~PI*size^2 tiles from it, which is more than enough.
    tile_map =
      tiles
      |> map_tiles

    # take and delete starting (center) tile
    center_tile = Map.get(tile_map, center)
    remaining_tiles = Map.delete(tile_map, center)

    spread({center, center_tile}, [], [], remaining_tiles, size, lambda)
  end

  # Converts list of tiles to a map, with xyz coordinates tuple works as a key
  def map_tiles(tiles) do
    Enum.reduce(tiles, %{}, fn tile, acc -> Map.put(acc, {tile.x, tile.y, tile.z}, tile) end)
  end

  def coordinates(tile) do
    {tile.x, tile.y, tile.z}
  end
end
