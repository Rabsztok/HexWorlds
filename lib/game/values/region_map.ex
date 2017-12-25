defmodule Game.RegionMap do
  def generate(size, {x,y,z}) do
    neighbors_offsets = [
      {0, 0, 0},
      {2 * size + 1, -size, -(size + 1)},
      {size + 1, -(2 * size + 1), size},
      {-size, -(size + 1), 2 * size + 1},
      {-(2 * size + 1), size, size + 1},
      {-(size + 1), 2 * size + 1, -size},
      {size, size + 1, -(2 * size + 1)}
    ]

    Enum.reduce(neighbors_offsets, %{}, fn ({x2, y2, z2}, neighbors) ->
      coordinates = {x + x2, y + y2, z + z2}
      Map.put(neighbors, coordinates, %{ x: x + x2, y: y + y2, z: z + z2, state: "waiting"})
    end)
  end
end