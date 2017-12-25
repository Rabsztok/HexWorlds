defmodule Game.RegionsGenerator do
  alias Game.Repo
  alias Game.Region
  import Logger

  defp save(regions) do
    {size, regions} = Repo.insert_all(
      Region,
      regions,
      on_conflict: :nothing,
      returning: true
    )

    regions
  end

  def call(world, size) do
    regions = Game.RegionMap.generate(size, {0,0,0})
    |> Enum.map(fn {coordinates, region} -> Map.put(region, :world_id, world.id) end)
    |> save()

    center_region = Enum.find(regions, fn (region) ->
      region.x == 0 && region.y == 0 && region.z == 0
    end)
    Game.TileGenerator.call(center_region, size)

    Enum.reduce(regions, %{}, fn region, _existing_tiles ->
      if !(region.x == 0 && region.y == 0 && region.z == 0) do
        Game.TileGenerator.call(region, size)
      end
#      [Task.async(fn -> Game.TileGenerator.call(region, size) end) | acc]
    end)
#    |> Enum.map(fn (task) -> Task.await(task, 50000) end)
  end
end