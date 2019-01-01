defmodule GameWeb.PlayerChannel do
  use Phoenix.Channel
  require Logger

  import Ecto.Query
  alias Game.Repo
  alias Game.Player
  alias Game.Tile

  def join("players:lobby", %{"world_id" => world_id}, socket) do
    players =
      Repo.all(
        from(
          player in Player,
          where: player.world_id == ^world_id
        )
      )

    {:ok, %{players: players}, socket}
  end

  def handle_in(
        "create",
        params,
        socket
      ) do
    player =
      Player.changeset(%Player{}, params)
      |> Repo.insert!()

    push(socket, "create", %{player: player})

    {:noreply, socket}
  end

  def handle_in(
        "move",
        %{"player_id" => player_id, "tile_id" => tile_id},
        socket
      ) do
    tile = Repo.get!(Tile, tile_id)

    player =
      Repo.get!(Player, player_id)
      |> Ecto.Changeset.change(tile_id: tile.id)
      |> Repo.update!()

    push(socket, "move", %{player: player})

    {:noreply, socket}
  end
end
