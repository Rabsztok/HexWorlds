defmodule Game.ForestsGenerator do
  import Ecto.Query
  alias Game.Repo
  alias Game.Tile

  def call(world, amount) do
    centers = Tile.Queries.random(world, amount)

    create_forests(world, centers)
  end

  def create_forests(world, [center | remaining_centers]) do
    plant_trees(world, center, :crypto.rand_uniform(3, 10))

    create_forests(world, remaining_centers)
  end

  def create_forests(_world, []) do
  end

  def plant_trees(world, center, range) when range > 0 do
    from(
      tile in Tile,
      where: tile.world_id == ^(world.id),
      where: tile.height > 2,
#      where: tile.fragment("\"terrain\"->\"type\"") in ["dirt", "forest"],
      where: tile.x < ^(center.x + range - :rand.uniform(3)),
      where: tile.y < ^(center.y + range - :rand.uniform(3)),
      where: tile.z < ^(center.z + range - :rand.uniform(3)),
      where: tile.x > ^(center.x - range + :rand.uniform(3)),
      where: tile.y > ^(center.y - range + :rand.uniform(3)),
      where: tile.z > ^(center.z - range + :rand.uniform(3)),
      update: [
        set: [terrain: ^(%{type: "forest", density: 6 - range/2})],
      ]
    )
    |> Repo.update_all([])

    plant_trees(world, center, range - 1)
  end

  def plant_trees(_world, _center, _range) do
  end
end