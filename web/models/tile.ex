defmodule Game.Tile do
  use Game.Web, :model

  @derive {Poison.Encoder, only: [:id, :x, :y, :z, :height, :terrain_type]}
  schema "tiles" do
    field :x, :integer
    field :y, :integer
    field :z, :integer
    field :height, :integer
    field :terrain_type, TerrainTypeEnum
    belongs_to :world, Game.World
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:world_id, :x, :y, :z, :height, :terrain_type])
    |> unique_constraint(:coordinates, name: :coordinates_index)
    |> validate_required([:world_id, :x, :y, :z, :terrain_type])
  end

  def random_terrain_type do
    Enum.random(TerrainTypeEnum.__enum_map__)
  end

  defmodule Queries do
    def within_range(position, range) do
      Game.Repo.all(
        from tile in Game.Tile,
        where: tile.x < ^(position.x + range),
        where: tile.y < ^(position.y + range),
        where: tile.z < ^(position.z + range),
        where: tile.x > ^(position.x - range),
        where: tile.y > ^(position.y - range),
        where: tile.z > ^(position.z - range),
        select: tile
      )
    end

    def random(size) do
      Game.Repo.all(
        from tile in Game.Tile,
        order_by: fragment("RANDOM()"),
        limit: ^size
      )
    end
  end
end
