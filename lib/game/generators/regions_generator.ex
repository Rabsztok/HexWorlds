defmodule Game.RegionsGenerator do
  alias Game.Repo
  alias Game.Region
  import Ecto.Query

  defp process_edge(region) do
    Region.set_state(region, "in_progress")

    Game.TileGenerator.call(region)

    Region.set_state(region, "edge")

    region
  end

  # generate new regions around current boundaries of the map, build a heightmap of them and mark them as new world edge.
  # existing regions are marked as "empty" - they are ready to be populated from now on.
  def expand(world) do
    regions = Repo.all(from region in Region, where: region.world_id == ^(world.id))
    neighbors = Enum.reduce(regions, [], fn region, neighbors ->
      neighbors ++ Game.RegionMap.generate_neighbors(world, region)
    end)

    Repo.update!(Ecto.Changeset.change(world, size: world.size + 1))

    odd_neighbors = Enum.take_every(neighbors, 2)
    even_neighbors = neighbors -- odd_neighbors

    Enum.map(odd_neighbors, fn region -> Task.async(fn -> process_edge(region) end) end)
    |> Task.yield_many(50000)

    Enum.map(even_neighbors, fn region -> Task.async(fn -> process_edge(region) end) end)
    |> Task.yield_many(50000)

    Enum.each(regions, fn region -> Region.set_state(region, "empty") end)
  end

  # create central region and expand it once initially
  def create(world) do
    center = Repo.insert! %Region{ x: 0, y: 0, z: 0, state: "initial", world_id: world.id}
    process_edge(center)

    Enum.each(1..1, fn _ -> expand(world) end)
  end

  # mark all empty region as complete - this code is ran after all assets are generated
  def complete(world) do
    from(
      region in Region,
      where: region.state == "empty",
      where: region.world_id == ^(world.id)
    )
    |> Repo.all
    |> Enum.each(fn region -> Region.set_state(region, "ready") end)
  end
end