defmodule Game.TileGenerator do
  alias Game.Repo
  alias Game.Tile

  defp call(x, y, z, size) when z <= size do
    Repo.insert(Tile.changeset(%Tile{}, %{x: x, y: y, z: z}))

    cond do
      x == size ->
        call(-size, y + 1, z, size)
      y == size ->
        call(-size, -size, z + 1, size)
      true ->
        call(x + 1, y, z, size)
    end
  end

  defp call(_x, _y, _z, _size) do
  end

  def call(size) do
    Task.Supervisor.async_nolink(Game.TaskSupervisor, fn ->
      call(-size, -size, -size, size)
    end)
  end
end