defmodule Game.WorldControllerTest do
  use Game.ConnCase

  alias Game.World
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, world_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing worlds"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, world_path(conn, :new)
    assert html_response(conn, 200) =~ "New world"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, world_path(conn, :create), world: @valid_attrs
    assert redirected_to(conn) == world_path(conn, :index)
    assert Repo.get_by(World, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, world_path(conn, :create), world: @invalid_attrs
    assert html_response(conn, 200) =~ "New world"
  end

  test "shows chosen resource", %{conn: conn} do
    world = Repo.insert! %World{}
    conn = get conn, world_path(conn, :show, world)
    assert html_response(conn, 200) =~ "Show world"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, world_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    world = Repo.insert! %World{}
    conn = get conn, world_path(conn, :edit, world)
    assert html_response(conn, 200) =~ "Edit world"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    world = Repo.insert! %World{}
    conn = put conn, world_path(conn, :update, world), world: @valid_attrs
    assert redirected_to(conn) == world_path(conn, :show, world)
    assert Repo.get_by(World, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    world = Repo.insert! %World{}
    conn = put conn, world_path(conn, :update, world), world: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit world"
  end

  test "deletes chosen resource", %{conn: conn} do
    world = Repo.insert! %World{}
    conn = delete conn, world_path(conn, :delete, world)
    assert redirected_to(conn) == world_path(conn, :index)
    refute Repo.get(World, world.id)
  end
end
