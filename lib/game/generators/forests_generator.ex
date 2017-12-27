defmodule Game.ForestsGenerator do
  import Ecto.Query
  alias Game.Repo
  alias Game.Tile
  import TileUtils

  def call(world_id, amount) do
    Repo.all(
      from tile in Tile,
      where: tile.world_id == ^world_id,
      where: tile.height >= 5,
      where: fragment("?->>'type' = ?", tile.terrain, ^"dirt"),
      order_by: fragment("RANDOM()"),
      limit: ^amount
    )
    |> Enum.map(fn center ->
      plant_trees(world_id, coordinates(center), 2 + :rand.uniform(8))
    end)
  end

  def plant_trees(world_id, {x,y,z}, range) when range > 0 do
    from(
      tile in Tile,
      where: tile.world_id == ^world_id,
      where: tile.height >= 5,
      where: fragment("?->>'type' = ?", tile.terrain, ^"dirt"),
      where: tile.x < ^(x + range - :rand.uniform(3)),
      where: tile.y < ^(y + range - :rand.uniform(3)),
      where: tile.z < ^(z + range - :rand.uniform(3)),
      where: tile.x > ^(x - range + :rand.uniform(3)),
      where: tile.y > ^(y - range + :rand.uniform(3)),
      where: tile.z > ^(z - range + :rand.uniform(3)),
      update: [
        set: [terrain: ^(%{type: "forest", density: 6 - range/2})],
      ]
    )
    |> Repo.update_all([])

    plant_trees(world_id, {x,y,z}, range - 1)
  end

  def plant_trees(_, _, _) do
  end
end