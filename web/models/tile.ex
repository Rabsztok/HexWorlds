defmodule Game.Tile do
  use Game.Web, :model

@derive {Poison.Encoder, only: [:id, :q, :r, :height, :type]}
  schema "tiles" do
    field :q, :integer
    field :r, :integer
    field :height, :integer
    field :type, TileTypeEnum
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:q, :r, :height])
    |> unique_constraint(:coordinates, name: :coordinates_index)
    |> validate_required([:q, :r, :height])
  end

  def random_tile_type do
    Enum.random(TileTypeEnum.__enum_map__)
  end

  defmodule Queries do
    def within_range(position, range) do
      Game.Repo.all(
        from tile in Game.Tile,
        where: tile.q < ^(position.q + range),
        where: tile.r < ^(position.r + range),
        where: tile.q > ^(position.q - range),
        where: tile.r > ^(position.r - range),
        select: tile
      )
    end
  end
end
