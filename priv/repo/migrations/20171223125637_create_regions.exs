defmodule Game.Repo.Migrations.CreateRegions do
  use Ecto.Migration

  def up do
    create table(:regions, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :x, :bigint
      add :y, :bigint
      add :z, :bigint
      add :state, :string
      add :world_id, references(:worlds, on_delete: :nothing, type: :uuid)
    end

    alter table(:tiles) do
      add :region_id, references(:regions, on_delete: :nothing, type: :uuid)
    end

    create unique_index(:regions, [:world_id, :x, :y, :z], name: :region_coordinates_index)
  end

  def down do
    alter table(:tiles) do
      remove :region_id
    end

    drop table(:regions)
  end
end
