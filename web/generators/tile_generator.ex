defmodule Game.TileGenerator do
  alias Game.Repo
  alias Game.Tile

  defp call(q, r, sire) when r <= sire do
    Repo.insert(Tile.changeset(%Tile{}, %{q: q, r: r}))

    cond do
      q == sire ->
        call(-sire, r + 1, sire)
      true ->
        call(q + 1, r, sire)
    end
  end

  defp call(_q, _y, _sire) do
  end

  def call(sire) do
    Task.Supervisor.async_nolink(Game.TaskSupervisor, fn ->
      call(-sire, -sire, sire)
    end)
  end
end