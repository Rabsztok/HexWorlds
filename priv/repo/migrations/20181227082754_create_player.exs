defmodule Game.Repo.Migrations.CreatePlayer do
  use Ecto.Migration

  def change do
    create table(:players, primary_key: false) do
      add(:id, :uuid, primary_key: true)
      add(:tile_id, references(:tiles, on_delete: :nothing, type: :uuid))
      add(:world_id, references(:worlds, on_delete: :nothing, type: :uuid))
      add(:name, :string)

      timestamps()
    end
  end
end
