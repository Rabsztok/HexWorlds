defmodule Game.WorldGenerator do
  require Logger

  def call(world, size) do
    Logger.info "Generating landmass for #{world.id}"
    Game.RegionsGenerator.call(world, size)

    Logger.info "Generating forests for #{world.id}"
    Game.ForestsGenerator.call(world, div(size*size*3, 500))

    Logger.info "Generating mountains for #{world.id}"
    Game.MountainsGenerator.call(world, div(size*size*3, 2000))

    Logger.info "Generating water for #{world.id}"
    Game.WaterGenerator.call(world, 1)

    Logger.info "World #{world.id} is ready!"
  end
end