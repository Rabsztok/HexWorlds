defmodule Game.MountainsGenerator do
  import Ecto.Query
  alias Game.Repo
  alias Game.Tile

  def call(world, amount) do
    peaks = Tile.Queries.random(world, amount)

    create_mountains(world, peaks)
  end

  def create_mountains(world, [peak | remaining_peaks]) do
    raise_terrain(world, peak, :crypto.rand_uniform(10, 15))

    create_mountains(world, remaining_peaks)
  end

  def create_mountains(_world, []) do
  end

  def raise_terrain(world, peak, range) when range > 0 do
    from(
      tile in Tile,
      where: tile.world_id == ^(world.id),
      where: tile.x < ^(peak.x + range),
      where: tile.y < ^(peak.y + range),
      where: tile.z < ^(peak.z + range),
      where: tile.x > ^(peak.x - range),
      where: tile.y > ^(peak.y - range),
      where: tile.z > ^(peak.z - range),
      update: [
        set: [terrain: ^(%{type: "stone"})],
        inc: [height: fragment("floor((random() + 1) * 2 * ?/10)", ^range)]
      ]
    )
    |> Repo.update_all([])

    raise_terrain(world, peak, range - 1)
  end

  def raise_terrain(_world, _peak, _range) do
  end
end