defmodule Game.Repo.Migrations.CreateTile do
  use Ecto.Migration

  def up do
    TerrainTypeEnum.create_type

    create table(:tiles) do
      add :x, :bigint
      add :y, :bigint
      add :z, :bigint
      add :height, :integer
      add :terrain_type, :terrain_type
      add :world_id, references(:worlds, on_delete: :nothing)
    end

    create unique_index(:tiles, [:world_id, :x, :y, :z], name: :coordinates_index)
  end

  def down do
    drop table(:tiles)

    TerrainTypeEnum.drop_type
  end
end
