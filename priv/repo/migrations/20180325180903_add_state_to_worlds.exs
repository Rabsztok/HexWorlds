defmodule Game.Repo.Migrations.AddStateToWorlds do
  use Ecto.Migration

  def change do
    alter table(:worlds) do
      add :size, :integer
    end
  end
end
