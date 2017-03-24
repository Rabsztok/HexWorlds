defmodule Game.WorldController do
  use Game.Web, :controller

  alias Game.World

  def index(conn, _params) do
    worlds = Repo.all(World)
    render(conn, "index.html", worlds: worlds)
  end

  def new(conn, _params) do
    changeset = World.changeset(%World{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"world" => world_params}) do
    changeset = World.changeset(%World{}, world_params)

    case Repo.insert(changeset) do
      {:ok, _world} ->
        Game.TileGenerator.call(10)

        conn
        |> put_flash(:info, "World created successfully.")
        |> redirect(to: world_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    world = Repo.get!(World, id)
    render(conn, "show.html", world: world)
  end

  def edit(conn, %{"id" => id}) do
    world = Repo.get!(World, id)
    changeset = World.changeset(world)
    render(conn, "edit.html", world: world, changeset: changeset)
  end

  def update(conn, %{"id" => id, "world" => world_params}) do
    world = Repo.get!(World, id)
    changeset = World.changeset(world, world_params)

    case Repo.update(changeset) do
      {:ok, world} ->
        conn
        |> put_flash(:info, "World updated successfully.")
        |> redirect(to: world_path(conn, :show, world))
      {:error, changeset} ->
        render(conn, "edit.html", world: world, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    world = Repo.get!(World, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(world)

    conn
    |> put_flash(:info, "World deleted successfully.")
    |> redirect(to: world_path(conn, :index))
  end
end
