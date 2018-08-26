defmodule Queries do
  alias Game.Tile
  alias Game.Region
  import Ecto.Query

  def tileWithRegion do
    from tile in Tile,
         join: region in Region,
         where: tile.region_id == region.id
  end
end