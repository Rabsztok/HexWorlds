defmodule Game.TileGenerator do
  alias Game.Repo
  alias Game.Tile

  defp call(world, x, z, size) when z <= size do
    Repo.insert(Tile.changeset(%Tile{},
      %{x: x, y: -x-z, z: z, world_id: world.id, terrain_type: "dirt"}))

    if x == size do
      call(world, -size, z + 1, size)
    else
      call(world, x + 1, z, size)
    end
  end

  defp call(_world, _x, _y, _size) do
  end

  def call(world, size) do
    Task.Supervisor.async_nolink(Game.TaskSupervisor, fn ->
      call(world, -size, -size, size)
    end)
  end
end