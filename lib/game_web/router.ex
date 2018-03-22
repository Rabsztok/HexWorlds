defmodule GameWeb.Router do
  use GameWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", GameWeb do
    pipe_through :api

    resources "/worlds", WorldController, except: [:update]
    resources "/tiles", TileController, only: [:index]
  end
end
