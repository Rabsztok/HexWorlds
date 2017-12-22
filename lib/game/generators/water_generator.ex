defmodule Game.WaterGenerator do
  import Ecto.Query
  alias Game.Repo
  alias Game.Tile

  def call(world, sea_level) do
    create_sea(world, sea_level)
    create_beach(world, sea_level + 1)
  end

  def create_sea(world, sea_level) do
    from(
      tile in Tile,
      where: tile.world_id == ^(world.id),
      where: tile.height <= ^sea_level,
      update: [
        set: [terrain: ^(%{type: "water"}), height: ^sea_level]
      ]
    )
    |> Repo.update_all([])
  end

  def create_beach(world, beach_level) do
    from(
      tile in Tile,
      where: tile.world_id == ^(world.id),
      where: tile.height == ^beach_level,
      update: [
        set: [terrain: ^(%{type: "sand"})]
      ]
    )
    |> Repo.update_all([])
  end
end