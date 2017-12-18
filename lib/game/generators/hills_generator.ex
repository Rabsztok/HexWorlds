defmodule Game.HillsGenerator do
  import Ecto.Query
  alias Game.Repo
  alias Game.Tile

  def call(world, amount) do
    from(
      tile in Tile,
      where: tile.world_id == ^(world.id),
      update: [ set: [height: 1] ]
    )
    |> Repo.update_all([])
    peaks = Tile.Queries.random(world, amount)

    create_hills(world, peaks)
  end

  def create_hills(world, [peak | remaining_peaks]) do
    raise_terrain(world, peak, :rand.uniform(10) + 5)

    create_hills(world, remaining_peaks)
  end

  def create_hills(_world, []) do
  end

  def raise_terrain(world, peak, range) when range > 3 do
    from(
      tile in Tile,
      where: tile.world_id == ^(world.id),
      where: tile.x < ^(peak.x + range - :rand.uniform(3)),
      where: tile.y < ^(peak.y + range - :rand.uniform(3)),
      where: tile.z < ^(peak.z + range - :rand.uniform(3)),
      where: tile.x > ^(peak.x - range + :rand.uniform(3)),
      where: tile.y > ^(peak.y - range + :rand.uniform(3)),
      where: tile.z > ^(peak.z - range + :rand.uniform(3)),
      update: [
        inc: [height: 1]
      ]
    )
    |> Repo.update_all([])

    raise_terrain(world, peak, range - :rand.uniform(3))
  end

  def raise_terrain(_world, _peak, _range) do
  end
end