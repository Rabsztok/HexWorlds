defmodule Game.RegionTest do
  use Game.ModelCase

  alias Game.Region

  @valid_attrs %{
    world_id: Ecto.UUID.generate(),
    x: 0,
    y: 0,
    z: 0,
    state: "waiting"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Region.changeset(%Region{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Region.changeset(%Region{}, @invalid_attrs)
    refute changeset.valid?
  end
end
