defmodule Game.MountainsGenerator do
  import Ecto.Query
  alias Game.Repo
  alias Game.Tile
  import TileUtils
  import Queries

  def call(world_id, amount) do
    Repo.all(
      from([tile, region] in tileWithRegion(),
        where: region.state == "empty",
        where: tile.world_id == ^world_id,
        order_by: fragment("RANDOM()"),
        limit: ^amount
      )
    )
    |> Enum.map(fn peak ->
      raise_terrain(world_id, coordinates(peak), 10 + :rand.uniform(10))
    end)

    from(
      tile in Tile,
      where: tile.world_id == ^world_id,
      where: tile.height < 5,
      where: fragment("?->>'type' = ?", tile.terrain, ^"stone"),
      update: [
        set: [terrain: ^%{type: "dirt"}]
      ]
    )
    |> Repo.update_all([])
  end

  def raise_terrain(world_id, {x, y, z}, range) when range > 3 do
    from(
      tile in Tile,
      where: tile.world_id == ^world_id,
      where: tile.x < ^(x + range - :rand.uniform(3)),
      where: tile.y < ^(y + range - :rand.uniform(3)),
      where: tile.z < ^(z + range - :rand.uniform(3)),
      where: tile.x > ^(x - range + :rand.uniform(3)),
      where: tile.y > ^(y - range + :rand.uniform(3)),
      where: tile.z > ^(z - range + :rand.uniform(3)),
      update: [
        set: [terrain: ^%{type: "stone"}],
        inc: [height: ^:rand.uniform(2)]
      ]
    )
    |> Repo.update_all([])

    next_x = x + round((:rand.uniform() - 0.5) * range)
    next_z = z + round((:rand.uniform() - 0.5) * range)
    next_peak = {next_x, -next_x - next_z, next_z}

    raise_terrain(world_id, next_peak, range - 1)

    # randomly spawn additional peak
    if :rand.uniform() > 0.7 && range > 10 do
      next_x = x + round((:rand.uniform() - 0.5) * (10 + range))
      next_z = z + round((:rand.uniform() - 0.5) * (10 + range))
      next_peak = {next_x, -next_x - next_z, next_z}

      raise_terrain(world_id, next_peak, range - 1)
    end
  end

  def raise_terrain(_, _, _) do
  end
end
