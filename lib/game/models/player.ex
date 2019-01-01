defmodule Game.Player do
  use Game, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @derive {Phoenix.Param, key: :id}
  @derive {Poison.Encoder, only: [:id, :name, :tile_id, :world_id]}

  schema "players" do
    field(:name, :string)

    belongs_to(:tile, Game.Tile, type: :binary_id)
    belongs_to(:world, Game.World, type: :binary_id)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:world_id, :tile_id, :name])
    |> validate_required([:world_id, :tile_id])
  end
end
