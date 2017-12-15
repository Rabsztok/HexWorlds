use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.

config :game, Game.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :game, Game.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  database: "postgres",
  hostname: "game_db_1",
  pool_size: 10
