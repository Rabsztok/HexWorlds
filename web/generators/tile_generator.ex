defmodule Game.TileGenerator do
  alias Game.Repo
  alias Game.Tile

  defp call(world, z, size) when z <= size do
    Repo.insert_all(
      Tile,
      Enum.map(-size..size, fn x -> [x: x, y: -x-z, z: z, height: 1, world_id: world.id, terrain: %{type: "dirt"}] end),
      on_conflict: :nothing
    )

    call(world, z + 1, size)
  end

  defp call(_world, _z, _size) do
  end

  def call(world, size) do
    call(world, -size, size)
  end
end