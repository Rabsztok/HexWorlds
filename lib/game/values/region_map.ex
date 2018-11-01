defmodule Game.RegionMap do
  alias Game.Region
  alias Game.Repo

  def generate_neighbors(world, region) do
    size = Region.size()

    neighbors_offsets = [
      {2 * size + 1, -size, -(size + 1)},
      {size + 1, -(2 * size + 1), size},
      {-size, -(size + 1), 2 * size + 1},
      {-(2 * size + 1), size, size + 1},
      {-(size + 1), 2 * size + 1, -size},
      {size, size + 1, -(2 * size + 1)}
    ]

    Enum.map(neighbors_offsets, fn {x2, y2, z2} ->
      result =
        %Region{}
        |> Region.changeset(%{
          x: region.x + x2,
          y: region.y + y2,
          z: region.z + z2,
          state: "waiting",
          world_id: world.id
        })
        |> Repo.insert()

      case result do
        {:ok, region} -> region
        {:error, _} -> nil
      end
    end)
    |> Enum.filter(fn region -> region end)
  end
end
