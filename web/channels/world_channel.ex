require IEx

defmodule Game.WorldChannel do
  use Phoenix.Channel

  alias Game.Repo
  alias Game.World

  def join("worlds:lobby", _message, socket) do
    worlds = Repo.all(World)
    {:ok, %{worlds: worlds}, socket}
  end

  def join("world:" <> _world_id, _params, _socket) do
    IEx.pry
    {:error, %{reason: "unauthorized"}}
  end

#  def handle_info({:after_join, _message}, socket) do
#    player_id = socket.assigns.player_id
#    player = %{id: player_id}
#    player = GameState.put_player(player)
#    broadcast! socket, "player:joined", %{player: player}
#    {:noreply, socket}
#  end

#  def handle_in("move", %{"coordinates" => coordinates}, socket) do
#    broadcast! socket, "move", %{coordinates: coordinates}
#    {:noreply, socket}
#  end
#
#  def handle_out("move", payload, socket) do
#    push socket, "move", payload
#    {:noreply, socket}
#  end
end