defmodule Game.Tile do
  use Game, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  @derive {Poison.Encoder, only: [:id, :x, :y, :z, :height, :terrain]}

  schema "tiles" do
    field(:x, :integer)
    field(:y, :integer)
    field(:z, :integer)
    field(:height, :integer)
    field(:terrain, :map)

    belongs_to(:region, Game.Region, type: :binary_id)
    belongs_to(:world, Game.World, type: :binary_id)
    has_many(:players, Game.Player, on_delete: :delete_all)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:world_id, :region_id, :x, :y, :z, :height, :terrain])
    |> unique_constraint(:coordinates, name: :coordinates_index)
    |> validate_required([:world_id, :region_id, :x, :y, :z, :terrain])
  end

  defmodule Queries do
    def within_range(world_id, {x, y, z}, range) do
      Game.Repo.all(
        from(tile in Game.Tile,
          where: tile.world_id == ^world_id,
          where: tile.x <= ^(x + range),
          where: tile.y <= ^(y + range),
          where: tile.z <= ^(z + range),
          where: tile.x >= ^(x - range),
          where: tile.y >= ^(y - range),
          where: tile.z >= ^(z - range),
          select: tile
        )
      )
    end

    def within_range(world_id, terrain_type, {x, y, z}, range) do
      Game.Repo.all(
        from(tile in Game.Tile,
          where: tile.world_id == ^world_id,
          where: fragment("?->>'type' = ?", tile.terrain, ^terrain_type),
          where: tile.x <= ^(x + range),
          where: tile.y <= ^(y + range),
          where: tile.z <= ^(z + range),
          where: tile.x >= ^(x - range),
          where: tile.y >= ^(y - range),
          where: tile.z >= ^(z - range),
          select: tile
        )
      )
    end

    def random(world_id, limit) do
      Game.Repo.all(
        from(tile in Game.Tile,
          where: tile.world_id == ^world_id,
          order_by: fragment("RANDOM()"),
          limit: ^limit
        )
      )
    end

    def random(world_id, terrain_type, limit) do
      Game.Repo.all(
        from(tile in Game.Tile,
          where: tile.world_id == ^world_id,
          where: fragment("?->>'type' = ?", tile.terrain, ^terrain_type),
          order_by: fragment("RANDOM()"),
          limit: ^limit
        )
      )
    end
  end
end
