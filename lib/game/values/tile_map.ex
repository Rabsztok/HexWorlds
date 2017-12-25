defmodule Game.TileMap do
  import Logger

  #  ToDo: Limit tiles to hexagon by limiting `y`

  defp generate(size, {x,y,z}, dx, dy) do
    tile = %{ x: x + dx, y: y + dy, z: z -(dx + dy) }

    cond do
      dy < min(size, size - dx) ->
        Map.put(
          generate(size, {x,y,z}, dx, dy + 1),
          {tile.x, tile.y, tile.z},
          tile
        )
      dx < size ->
        Map.put(
          generate(size, {x,y,z}, dx + 1, max(-size, -size - (dx + 1))),
          {tile.x, tile.y, tile.z},
          tile
        )
      true ->
        Map.put(
          %{},
          {tile.x, tile.y, tile.z},
          tile
        )
    end
  end

  def generate(size, {x,y,z}) do
    generate(size, {x,y,z}, -size, max(-size, 0))
  end

  def neighbors(tile_map, {x,y,z}) do
    neighbors_offsets = [
      {1, -1, 0}, {1, 0, -1}, {0, 1, -1},
      {-1, 1, 0}, {-1, 0, 1}, {0, -1, 1}
    ]

    Enum.reduce(neighbors_offsets, %{}, fn ({x2,y2,z2}, neighbors) ->
      coordinates = {x+x2, y+y2, z+z2}
      tile = Map.get(tile_map, coordinates)

      if tile do
        Map.put(neighbors, coordinates, tile)
      else
        neighbors
      end
    end)
  end

  def neighbors(tile_map, coordinates, radius) do
    neighbors = Enum.filter(tile_map, fn {tile_coordinates, _} ->
      {x,y,z} = coordinates
      {x2,y2,z2} = tile_coordinates

      (abs(x2 - x) + abs(y2 - y) + abs(z2 - z)) / 2 < radius
    end)

    Enum.reduce(neighbors, %{}, fn ({coordinates, tile}, tiles) -> Map.put(tiles, coordinates, tile) end)
  end
end