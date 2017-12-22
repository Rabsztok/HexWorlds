defmodule Game.WorldGenerator do
  def call(world, size) do
    Game.LandmassGenerator.call(world, size)
    Game.ForestsGenerator.call(world, div(size*size*3, 500))
#    Game.MountainsGenerator.call(world, div(tiles_count, 2000))
    Game.WaterGenerator.call(world, 1)
  end
end