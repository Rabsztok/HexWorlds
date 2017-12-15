defmodule GameWeb.PageController do
  use GameWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
