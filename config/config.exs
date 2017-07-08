# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :chevpr,
  ecto_repos: [Chevpr.Repo]

# Configures the endpoint
config :chevpr, Chevpr.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0M+5DNdvZBkgt+Pf5N+9ZiSd1NNEY/aUBSGxwyNL7aF+fpl5ppZlV+jhMAbKClmw",
  render_errors: [view: Chevpr.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Chevpr.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  issuer: "Chevpr.#{Mix.env}",
  ttl: {30, :days},
  verify_issuer: true,
  serializer: Chevpr.GuardianSerializer,
  secret_key: System.get_env("GUARDIAN_SECRET_KEY")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
