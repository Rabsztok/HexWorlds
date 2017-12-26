defmodule Game.WorldGenerator do
  require Logger
  import Ecto.Query

  def call(world, size) do
    Logger.info "Generating landmass for #{world.id}"
    Game.RegionsGenerator.call(world, size)

    tiles_count = Game.Repo.one(
      from tile in Game.Tile,
      where: tile.world_id == ^world.id,
      select: count(tile.id)
    )

    Logger.info "Generating forests for #{world.id}"
    Game.ForestsGenerator.call(world, div(tiles_count, 500))

    Logger.info "Generating mountains for #{world.id}"
    Game.MountainsGenerator.call(world, div(tiles_count, 2000))

    Logger.info "Generating water for #{world.id}"
    Game.WaterGenerator.call(world, 1)

    Logger.info "World #{world.id} with #{tiles_count} tiles is ready!"
  end
end