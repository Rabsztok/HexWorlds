defmodule GameWeb.WorldChannel do
  use GameWeb, :channel

  alias Game.Repo
  alias Game.World

  def join("worlds:lobby", _message, socket) do
    worlds = Repo.all(World)
    {:ok, %{worlds: worlds}, socket}
  end

  def handle_in("create", %{"world" => world, "size" => size}, socket) do
    changeset = World.changeset(%World{}, world)
    {generation_size, _} = Integer.parse(size)

    case Repo.insert(changeset) do
      {:ok, world} ->
        Task.start_link(fn -> Game.WorldGenerator.call(world, generation_size) end)

        Endpoint.broadcast("worlds:lobby", "add", %{world: world})
        {:reply, {:success, world}, socket}
      {:error, changeset} ->
        errors = Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
        {:reply, {:error, errors}, socket}
    end
  end

  def handle_in("delete", %{"id" => id}, socket) do
    world = Repo.get!(World, id)

    Repo.delete!(world)

    Endpoint.broadcast("worlds:lobby", "remove", %{world: world})
    {:reply, {:success, world}, socket}
  end
end