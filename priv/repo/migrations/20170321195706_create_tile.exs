defmodule Game.Repo.Migrations.CreateTile do
  use Ecto.Migration

  def up do
    create table(:tiles, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :x, :bigint
      add :y, :bigint
      add :z, :bigint
      add :height, :integer
      add :terrain, :json
      add :world_id, references(:worlds, on_delete: :nothing, type: :uuid)
    end

    create unique_index(:tiles, [:world_id, :x, :y, :z], name: :coordinates_index)
  end

  def down do
    drop table(:tiles)
  end
end
