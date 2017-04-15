defmodule Game.World do
  use Game.Web, :model

  @derive {Poison.Encoder, only: [:id, :name]}
  schema "worlds" do
    field :name, :string
    has_many :tiles, Game.Tile

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end

  def random_coordinate do
    :crypto.rand_uniform(-100, 100)
  end
end