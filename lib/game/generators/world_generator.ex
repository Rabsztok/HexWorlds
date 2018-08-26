defmodule Game.WorldGenerator do
  require Logger
  import Ecto.Query
  import Queries

  defp build_content(world) do
    tiles_count = Game.Repo.one(
      from [tile, region] in tileWithRegion(),
      where: region.state == "empty",
      where: tile.world_id == ^world.id,
      select: count(tile.id)
    )

    Logger.info "Generating mountains for #{world.id}"
    Game.MountainsGenerator.call(world.id, div(tiles_count, 6000))

    Logger.info "Generating forests for #{world.id}"
    Game.ForestsGenerator.call(world.id, div(tiles_count, 1000))

    Logger.info "Generating water for #{world.id}"
    Game.WaterGenerator.call(world, 1)

    Game.RegionsGenerator.complete(world)
  end

  def create(world) do
    Game.RegionsGenerator.create(world)

    build_content(world)
  end

  def expand(world) do
    Game.RegionsGenerator.expand(world)

    build_content(world)
  end
end