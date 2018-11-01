defmodule Game.World do
  use Game, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Poison.Encoder, only: [:id, :name, :state, :size, :regions]}

  schema "worlds" do
    field(:name, :string)
    field(:size, :integer)
    has_many(:tiles, Game.Tile, on_delete: :delete_all)
    has_many(:regions, Game.Region, on_delete: :delete_all)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :size])
    |> validate_required([:name, :size])
  end
end
