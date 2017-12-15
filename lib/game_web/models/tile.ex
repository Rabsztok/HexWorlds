defmodule GameWeb.Tile do
  use GameWeb, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  @derive {Poison.Encoder, only: [:id, :x, :y, :z, :height, :terrain]}

  schema "tiles" do
    field :x, :integer
    field :y, :integer
    field :z, :integer
    field :height, :integer
    field :terrain, :map

    belongs_to :world, GameWeb.World
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:world_id, :x, :y, :z, :height, :terrain])
    |> unique_constraint(:coordinates, name: :coordinates_index)
    |> validate_required([:world_id, :x, :y, :z, :terrain])
  end

  defmodule Queries do
    def within_range(world_id, position, range) do
      Game.Repo.all(
        from tile in GameWeb.Tile,
        where: tile.world_id == ^(world_id),
        where: tile.x < ^(position.x + range),
        where: tile.y < ^(position.y + range),
        where: tile.z < ^(position.z + range),
        where: tile.x > ^(position.x - range),
        where: tile.y > ^(position.y - range),
        where: tile.z > ^(position.z - range),
        select: tile
      )
    end

    def random(world, limit) do
      Game.Repo.all(
        from tile in GameWeb.Tile,
        where: tile.world_id == ^(world.id),
        order_by: fragment("RANDOM()"),
        limit: ^limit
      )
    end
  end
end
