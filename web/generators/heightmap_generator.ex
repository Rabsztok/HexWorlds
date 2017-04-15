defmodule Game.HeightmapGenerator do
  import Ecto.Query
  alias Game.Repo
  alias Game.Tile

  def create_peaks([tile | remaining_tiles]) do
    height = :crypto.rand_uniform(1, 10)
    IO.puts(height)
    Repo.update!(Tile.changeset(tile, %{height: height}))

    create_peaks(remaining_tiles)
  end

  def create_peaks([]) do
  end

  def create_slopes([slope | remaining_slopes]) do
    height = avg_height_within_range(slope, 3)
    Repo.update!(Tile.changeset(slope, %{height: height}))

    create_slopes(remaining_slopes)
  end

  def create_slopes([]) do
  end

  def call() do
    Game.Repo.update_all(Game.Tile, [set: [height: nil]])

    peaks = Tile.Queries.random(25)
    create_peaks(peaks)

    create_slopes(remaining_slopes())
    create_slopes(remaining_slopes())
  end

  # Queries:

  def remaining_slopes() do
    Repo.all(
          from tile in Tile,
          order_by: fragment("RANDOM()"),
          where: is_nil(tile.height)
        )
  end

  def avg_height_within_range(position, range) do
    average = Repo.one!(
      from tile in Tile,
      where: not(is_nil(tile.height)),
      where: tile.x < ^(position.x + range),
      where: tile.y < ^(position.y + range),
      where: tile.z < ^(position.z + range),
      where: tile.x > ^(position.x - range),
      where: tile.y > ^(position.y - range),
      where: tile.z > ^(position.z - range),
      select: avg(tile.height)
    )
    if average do
      round(Decimal.to_float(average))
    end
  end
end