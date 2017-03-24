defmodule Game.WorldTest do
  use Game.ModelCase

  alias Game.World

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = World.changeset(%World{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = World.changeset(%World{}, @invalid_attrs)
    refute changeset.valid?
  end
end
