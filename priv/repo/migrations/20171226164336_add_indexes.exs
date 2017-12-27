defmodule Game.Repo.Migrations.AddIndexes do
  use Ecto.Migration
  @disable_ddl_transaction true

  def change do
    create index("tiles", [:world_id], concurrently: true)
    create index("tiles", [:region_id], concurrently: true)
    create index("regions", [:world_id], concurrently: true)
  end
end
