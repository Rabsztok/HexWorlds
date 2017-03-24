defmodule Game.Repo.Migrations.CreateTile do
  use Ecto.Migration

  def up do
    TileTypeEnum.create_type

    create table(:tiles) do
      add :x, :bigint
      add :y, :bigint
      add :z, :bigint
      add :type, :tile_type
    end

    create unique_index(:tiles, [:x, :y, :z], name: :coordinates_index)
  end

  def down do
    drop table(:tiles)

    TileTypeEnum.drop_type
  end
end
