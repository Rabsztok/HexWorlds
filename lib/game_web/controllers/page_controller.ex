defmodule GameWeb.PageController do
  use Game.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
