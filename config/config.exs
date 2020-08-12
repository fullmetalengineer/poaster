# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :poaster,
  ecto_repos: [Poaster.Repo]


# Configures the endpoint
config :poaster, PoasterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "nHnTZnFQnbTod5PpINh8JZornVnHule/qIX3HdtyirzUkuURg3gXiAc2Xvf96rHi",
  seed_token: "poaster!user!auth",
  render_errors: [view: PoasterWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Poaster.PubSub,
  live_view: [signing_salt: "RY7n86OO"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
