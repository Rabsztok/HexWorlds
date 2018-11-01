defmodule Game.World do
  use Game, :model

  @derive {Poison.Encoder, only: [:id, :name, :state, :size, :regions]}

  schema "worlds" do
    field :name, :string
    field :size, :integer
    has_many :tiles, Game.Tile, on_delete: :delete_all
    has_many :regions, Game.Region, on_delete: :delete_all

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