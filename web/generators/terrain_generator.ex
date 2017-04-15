#defmodule Game.TerrainGenerator do
#  import Ecto.Query
#  alias Game.Repo
#  alias Game.Tile
#
#  def call() do
#    peaks = Tile.Queries.random(25)
#    create_peaks(peaks)
#
#    create_slopes(remaining_slopes())
#    create_slopes(remaining_slopes())
#  end
#
#  #  private functions
#
#  defp create_peaks([peak | remaining_tiles]) do
#    height = :crypto.rand_uniform(1, 10)
#    Repo.update!(Tile.changeset(peak, %{height: height}))
#
#    create_hexes(peak, height)
#    create_peaks(remaining_tiles)
#  end
#
#  defp create_peaks([]) do
#  end
#
#  defp create_slopes([slope | remaining_slopes]) do
#    height = avg_height_within_range(slope, 3) || :crypto.rand_uniform(1, 10)
#    Repo.update!(Tile.changeset(slope, %{height: height}))
#
#    create_hexes(slope, height)
#    create_slopes(remaining_slopes)
#  end
#
#  defp create_slopes([]) do
#  end
#
#  defp create_hexes(tile, height) when height > 0 do
#    hex = Ecto.build_assoc(tile, :hexes, type: Tile.random_terrain_type())
#    Repo.insert!(hex)
#
#    create_hexes(tile, height - 1)
#  end
#
#  defp create_hexes(_tile, _height) do
#  end
#
#  # Queries:
#
#  defp remaining_slopes() do
#    Repo.all(
#          from tile in Tile,
#          order_by: fragment("RANDOM()"),
#          where: is_nil(tile.height)
#        )
#  end
#
#  defp avg_height_within_range(position, range) do
#    average = Repo.one!(
#      from tile in Tile,
#      where: not(is_nil(tile.height)),
#      where: tile.x < ^(position.x + range),
#      where: tile.y < ^(position.y + range),
#      where: tile.z < ^(position.z + range),
#      where: tile.x > ^(position.x - range),
#      where: tile.y > ^(position.y - range),
#      where: tile.z > ^(position.z - range),
#      select: avg(tile.height)
#    )
#
#    if average do
#      round(Decimal.to_float(average))
#    end
#  end
#end