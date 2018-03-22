defmodule GameWeb.TileView do
  use GameWeb, :view

  def render("index.json", %{tiles: tiles}) do
    %{ tiles: Enum.map(tiles, &tile_json/1) }
  end

  def tile_json(tile) do
    %{
      id: tile.id,
      x: tile.x,
      y: tile.y,
      z: tile.z,
      height: tile.height,
      terrain: tile.terrain
    }
  end
end