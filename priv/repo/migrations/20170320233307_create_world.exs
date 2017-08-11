defmodule Game.Repo.Migrations.CreateWorld do
  use Ecto.Migration

  def change do
    create table(:worlds, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string

      timestamps()
    end

  end
end
