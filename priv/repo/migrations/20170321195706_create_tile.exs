defmodule Game.Repo.Migrations.CreateTile do
  use Ecto.Migration

  def up do
    TileTypeEnum.create_type

    create table(:tiles) do
      add :q, :bigint
      add :r, :bigint
      add :height, :integer
      add :type, :tile_type
    end

    create unique_index(:tiles, [:q, :r], name: :coordinates_index)
  end

  def down do
    drop table(:tiles)

    TileTypeEnum.drop_type
  end
end
