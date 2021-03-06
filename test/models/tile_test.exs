defmodule Game.TileTest do
  use Game.ModelCase

  alias Game.Tile

  @valid_attrs %{
    world_id: Ecto.UUID.generate(),
    region_id: Ecto.UUID.generate(),
    x: 0,
    y: 0,
    z: 0,
    height: 1,
    terrain: %{type: "water"}
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Tile.changeset(%Tile{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Tile.changeset(%Tile{}, @invalid_attrs)
    refute changeset.valid?
  end
end
