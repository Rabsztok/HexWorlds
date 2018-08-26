defmodule GameWeb.WorldChannel do
  use GameWeb, :channel

  alias Game.Repo
  alias Game.World

  def join("worlds:lobby", _message, socket) do
    worlds = World
             |> Repo.all()
             |> Repo.preload(:regions)
    {:ok, %{worlds: worlds}, socket}
  end

  def handle_in("create", %{"world" => world}, socket) do
    changeset = World.changeset(%World{size: 1}, world)

    case Repo.insert(changeset) do
      {:ok, world} ->
        Task.start_link(fn -> Game.WorldGenerator.create(world) end)

        world = World
                |> Repo.get!(world.id)
                |> Repo.preload(:regions)
        Endpoint.broadcast("worlds:lobby", "add", %{world: world})
        {:reply, {:success, world}, socket}
      {:error, changeset} ->
        errors = Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
        {:reply, {:error, errors}, socket}
    end
  end

  def handle_in("expand", %{"id" => id}, socket) do
    world = World
            |> Repo.get!(id)
            |> Repo.preload(:regions)

    Task.start_link(fn -> Game.WorldGenerator.expand(world) end)

    {:reply, {:success, world}, socket}
  end

  def handle_in("delete", %{"id" => id}, socket) do
    world = World
            |> Repo.get!(id)
            |> Repo.preload(:regions)

    Repo.delete!(world)

    Endpoint.broadcast("worlds:lobby", "remove", %{world: world})
    {:reply, {:success, world}, socket}
  end
end