defmodule Game.RegionsGenerator do
  alias Game.Repo
  alias Game.Region
  import Ecto.Query
  import Logger

  defp process_region(region) do
    Repo.update!(Ecto.Changeset.change(region, state: "processing"))

    Game.TileGenerator.call(region)

    Repo.update!(Ecto.Changeset.change(region, state: "ready"))

    region
  end

  def expand(world) do
    regions = Repo.all(from region in Region, where: region.world_id == ^(world.id))
    neighbors = Enum.reduce(regions, [], fn region, neighbors ->
      neighbors ++ Game.RegionMap.generate_neighbors(world, region)
    end)

    odd_neighbors = Enum.take_every(neighbors, 2)
    even_neighbors = neighbors -- odd_neighbors

    Enum.map(odd_neighbors, fn region -> Task.async(fn -> process_region(region) end) end)
    |> Task.yield_many(50000)

    Enum.map(even_neighbors, fn region -> Task.async(fn -> process_region(region) end) end)
    |> Task.yield_many(50000)
  end

  def call(world, size) do
    {:ok, center} = Repo.insert %Region{ x: 0, y: 0, z: 0, state: "processing", world_id: world.id}
    Game.TileGenerator.call(center)
    Repo.update!(Ecto.Changeset.change(center, state: "ready"))

    Enum.each(1..size, fn _ -> expand(world) end)
  end
end