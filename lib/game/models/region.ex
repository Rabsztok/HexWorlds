defmodule Game.Region do
  use Game, :model

  @size 50

  def size, do: @size

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  @derive {Poison.Encoder, only: [:id, :x, :y, :z, :state]}

  schema "regions" do
    field :x, :integer
    field :y, :integer
    field :z, :integer
    field :state, :string

    has_many :tiles, Game.Tile, on_delete: :nothing
    belongs_to :world, Game.World
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:world_id, :x, :y, :z])
    |> unique_constraint(:coordinates, name: :region_coordinates_index)
    |> validate_required([:world_id, :x, :y, :z])
  end

  def set_state(region, state) do
    Game.Repo.update!(Ecto.Changeset.change(region, state: state))

    world = Game.World
            |> Game.Repo.get!(region.world_id)
            |> Game.Repo.preload(:regions)
    GameWeb.Endpoint.broadcast("worlds:lobby", "update", %{world: world})
  end
end