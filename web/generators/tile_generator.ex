defmodule Game.TileGenerator do
  alias Game.Repo
  alias Game.Tile

  defp call(q, r, size) when r <= size do
    height = :crypto.rand_uniform(1, 5)
    Repo.insert(Tile.changeset(%Tile{}, %{q: q, r: r, height: height}))

    cond do
      q == size ->
        call(-size, r + 1, size)
      true ->
        call(q + 1, r, size)
    end
  end

  defp call(_q, _y, _size) do
  end

  def call(size) do
    Task.Supervisor.async_nolink(Game.TaskSupervisor, fn ->
      call(-size, -size, size)
    end)
  end
end