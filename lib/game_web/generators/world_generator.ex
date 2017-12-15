defmodule GameWeb.WorldGenerator do
  alias Game.Repo
  alias GameWeb.Tile

  def call(world, size) do
    GameWeb.TileGenerator.call(world, size)

    tiles_count = Repo.aggregate Tile, :count, :id

    GameWeb.HillsGenerator.call(world, div(tiles_count, 200))
    GameWeb.ForestsGenerator.call(world, div(tiles_count, 500))
    GameWeb.MountainsGenerator.call(world, div(tiles_count, 2000))
    GameWeb.WaterGenerator.call(world, 1)
  end
end