defmodule Game.Repo.Migrations.CreateWorld do
  use Ecto.Migration

  def change do
    create table(:worlds) do
      add :name, :string

      timestamps()
    end

  end
end
