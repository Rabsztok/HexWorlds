defmodule Game.TileTest do
  use Game.ModelCase

  alias Game.Tile

  @valid_attrs %{type: "some content"}
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
