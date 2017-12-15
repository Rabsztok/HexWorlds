# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :game,
  ecto_repos: [Game.Repo]

# Configures the endpoint
config :game, GameWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "US6enMva0ImIIF7nsK7qlmlmVWNZcSod2V+kgw5l2D5yS2IBKgk2iGERMiVF+XD6",
  render_errors: [view: GameWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Game.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
