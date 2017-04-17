defmodule Game.WorldGenerator do
  alias Game.Repo
  alias Game.Tile

  def call(world, size) do
    Game.TileGenerator.call(world, size)

    tiles_count = Repo.aggregate Tile, :count, :id

    Game.HillsGenerator.call(world, div(tiles_count, 200))
    Game.MountainsGenerator.call(world, div(tiles_count, 1500))
    Game.WaterGenerator.call(world, 1)
  end
end