defmodule Game.TileGenerator do
  alias Game.Repo
  alias Game.Tile
  alias Game.Region

  defp calculate_height(
         {coordinates, tile},
         calculated_tiles,
         neighbors,
         remaining_tiles,
         boundary_tiles
       )
       when map_size(neighbors) > 0 do
    calculated_and_boundary_tiles = Map.merge(boundary_tiles, calculated_tiles)
    calculated_neighbors = Game.TileMap.neighbors(calculated_and_boundary_tiles, coordinates)

    calculated_neighbors_height =
      Enum.reduce(calculated_neighbors, 0, fn {_, neighbor}, sum ->
        sum + (Map.get(neighbor, :height, 0) || 0)
      end)

    height =
      if map_size(calculated_neighbors) > 0 do
        round(
          calculated_neighbors_height / map_size(calculated_neighbors) +
            :math.sqrt(:rand.uniform() * 16) * (:rand.uniform() - 0.5)
        )
      else
        :rand.uniform(10) - 5
      end

    tile = Map.put(tile, :height, height)
    calculated_tiles = Map.put(calculated_tiles, coordinates, tile)
    neighbors = Map.merge(neighbors, Game.TileMap.neighbors(remaining_tiles, coordinates))
    remaining_tiles = Map.drop(remaining_tiles, Map.keys(neighbors))
    {next_coordinates, next_tile} = Enum.random(neighbors)
    neighbors = Map.delete(neighbors, next_coordinates)

    Map.put(
      calculate_height(
        {next_coordinates, next_tile},
        calculated_tiles,
        neighbors,
        remaining_tiles,
        boundary_tiles
      ),
      coordinates,
      tile
    )
  end

  defp calculate_height({coordinates, tile}, calculated_tiles, %{}, %{}, %{}) do
    calculated_neighbors = Game.TileMap.neighbors(calculated_tiles, coordinates)

    calculated_neighbors_height =
      Enum.reduce(calculated_neighbors, 0, fn {_, neighbor}, sum ->
        sum + (Map.get(neighbor, :height, 0) || 0)
      end)

    tile =
      Map.put(
        tile,
        :height,
        round(
          calculated_neighbors_height / map_size(calculated_neighbors) +
            :math.sqrt(:rand.uniform() * 16) * (:rand.uniform() - 0.5)
        )
      )

    Map.put(calculated_tiles, coordinates, tile)
  end

  defp calculate_height(tiles, boundary_tiles) do
    neighbors =
      Enum.reduce(tiles, %{}, fn {coords, tile}, acc ->
        if map_size(Game.TileMap.neighbors(boundary_tiles, coords)) > 0 do
          Map.put(acc, coords, tile)
        else
          acc
        end
      end)

    remaining_tiles = Map.drop(tiles, Map.keys(neighbors))
    {next_coordinates, next_tile} = Enum.random(neighbors)
    neighbors = Map.delete(neighbors, next_coordinates)

    calculate_height(
      {next_coordinates, next_tile},
      %{},
      neighbors,
      remaining_tiles,
      boundary_tiles
    )
  end

  def calculate_height(tiles) do
    coordinates = {0, 0, 0}
    {tile, remaining_tiles} = Map.pop(tiles, coordinates)
    tile = Map.put(tile, :height, :rand.uniform(10) - 5)
    neighbors = Game.TileMap.neighbors(remaining_tiles, coordinates)
    remaining_tiles = Map.drop(remaining_tiles, Map.keys(neighbors))

    Map.put(
      calculate_height({coordinates, tile}, %{}, neighbors, remaining_tiles, %{}),
      coordinates,
      tile
    )
  end

  defp save(tiles) do
    Repo.insert_all(
      Tile,
      tiles
    )
  end

  def call(region) do
    center = {region.x, region.y, region.z}
    tiles = Game.TileMap.generate(center)

    tiles =
      if center == {0, 0, 0} do
        calculate_height(tiles)
      else
        boundary_tiles = Tile.Queries.within_range(region.world_id, center, Region.size() + 1)

        boundary_tiles =
          Enum.reduce(boundary_tiles, %{}, fn tile, acc ->
            Map.put(acc, {tile.x, tile.y, tile.z}, %{
              x: tile.x,
              y: tile.y,
              z: tile.z,
              height: tile.height
            })
          end)

        calculate_height(tiles, boundary_tiles)
      end

    Map.values(tiles)
    |> Enum.map(fn tile ->
      tile
      |> Map.put(:terrain, %{type: "dirt"})
      |> Map.put(:region_id, region.id)
      |> Map.put(:world_id, region.world_id)
    end)
    |> Enum.chunk_every(5000)
    |> Enum.each(fn chunk -> save(chunk) end)

    region
  end
end
