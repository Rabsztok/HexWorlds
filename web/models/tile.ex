defmodule Game.Tile do
  use Game.Web, :model

  schema "tiles" do
    field :x, :integer
    field :y, :integer
    field :z, :integer
    field :type, TileTypeEnum
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:x, :y, :z])
    |> unique_constraint(:coordinates, name: :coordinates_index)
    |> validate_required([:x, :y, :z])
  end

  def random_tile do
    Enum.random(TileTypeEnum.__enum_map__)
  end
end
