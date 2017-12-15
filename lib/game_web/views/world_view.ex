defmodule GameWeb.WorldView do
  use Game.Web, :view

  def render("index.json", %{worlds: worlds}) do
    %{ worlds: Enum.map(worlds, &world_json/1) }
  end

  def render("show.json", %{world: world}) do
    %{ world: world_json(world) }
  end

  def world_json(world) do
    %{
      id: world.id,
      name: world.name,
      inserted_at: world.inserted_at,
      updated_at: world.updated_at
    }
  end
end