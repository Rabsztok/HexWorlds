defmodule GameWeb.WorldController do
  use GameWeb, :controller

  alias Game.World

  def index(conn, _params) do
    worlds = Repo.all(World)
    render(conn, "index.json", worlds: worlds)
  end

  def show(conn, %{"id" => id}) do
    world = Repo.get!(World, id)
    render(conn, "show.json", world: world)
  end

  def create(conn, %{"world" => world_params, "size" => size }) do
    changeset = World.changeset(%World{}, world_params)
    generation_size = elem(Integer.parse(size), 0)

    case Repo.insert(changeset) do
      {:ok, world} ->
        Task.start_link(fn -> Game.WorldGenerator.call(world, generation_size) end)

        render(conn, "show.json", world: world)
      {:error, changeset} ->
        render(conn, "error.json", changeset: changeset)
    end
  end

#  def update(conn, %{"id" => id, "world" => world_params}) do
#    world = Repo.get!(World, id)
#    changeset = World.changeset(world, world_params)
#
#    case Repo.update(changeset) do
#      {:ok, world} ->
#        conn
#        |> put_flash(:info, "World updated successfully.")
#        |> redirect(to: world_path(conn, :show, world))
#      {:error, changeset} ->
#        render(conn, "edit.html", world: world, changeset: changeset)
#    end
#  end
#
  def delete(conn, %{"id" => id}) do
    world = Repo.get!(World, id)

    Repo.delete!(world)

    render(conn, "show.json", world: world)
  end
end
