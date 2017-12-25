defmodule Game.Region do
  use Game, :model

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
    |> cast(params, [:x, :y, :z])
    |> unique_constraint(:coordinates, name: :region_coordinates_index)
    |> validate_required([:x, :y, :z])
  end
end