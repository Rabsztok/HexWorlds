defmodule GameWeb do
  @moduledoc """
  A module that keeps using definitions for controllers,
  views and so on.

  This can be used in your application as:

      use GameWeb, :controller
      use GameWeb, :view

  The definitions below will be executed for every view,
  controller, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below.
  """

	@primary_key {:id, :binary_id, autogenerate: true}
	@foreign_key_type :binary_id

  def model do
    quote do
      use Ecto.Schema

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
    end
  end

  def controller do
    quote do
      use Phoenix.Controller, namespace: GameWeb

      alias Game.Repo
      import Ecto
      import Ecto.Query

      import GameWeb.Router.Helpers
      import GameWeb.Gettext
    end
  end

  def view do
  end

  def router do
    quote do
      use Phoenix.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel

      alias Game.Repo
      import Ecto
      import Ecto.Query
      import GameWeb.Gettext
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
