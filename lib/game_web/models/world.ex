defmodule GameWeb.World do
  use Game.Web, :model

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  @derive {Poison.Encoder, only: [:id, :name]}

  schema "worlds" do
    field :name, :string
    has_many :tiles, GameWeb.Tile, on_delete: :delete_all

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