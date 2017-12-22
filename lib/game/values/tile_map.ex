defmodule Game.TileMap do
  import Logger

  defp generate(x, z, size) when x < size do
    tile = %{
      x: x,
      y: -x - z,
      z: z,
      terrain: %{type: "dirt"},
    }

    Map.put(generate(x + 1, z, size), {x, -x - z, z}, tile)
  end

  defp generate(x, z, size) when z < size do
    tile = %{
      x: x,
      y: -x - z,
      z: z,
      terrain: %{type: "dirt"},
    }

    Map.put(generate(-size, z + 1, size), {x, -x - z, z}, tile)
  end

  defp generate(x, z, size) do
    tile = %{
      x: x,
      y: -x - z,
      z: z,
      terrain: %{type: "dirt"},
    }
    %{ {x, -x - z, z} => tile }
  end

  def generate(size) do
    generate(-size, -size, size)
  end

  def neighbors(tile_map, {x,y,z}) do
    neighbors_coordinates = [
      {1, -1, 0}, {1, 0, -1}, {0, 1, -1},
      {-1, 1, 0}, {-1, 0, 1}, {0, -1, 1}
    ]

    Enum.reduce(neighbors_coordinates, %{}, fn ({x2,y2,z2}, neighbors) ->
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
    neighbors = Enum.filter(tile_map, fn {tile_coordinates, tile} ->
      {x,y,z} = coordinates
      {x2,y2,z2} = tile_coordinates

      (abs(x2 - x) + abs(y2 - y) + abs(z2 - z)) / 2 < radius
    end)

    Enum.reduce(neighbors, %{}, fn ({coordinates, tile}, tiles) -> Map.put(tiles, coordinates, tile) end)
  end
end