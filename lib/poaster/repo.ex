defmodule Poaster.Repo do
  use Ecto.Repo,
    otp_app: :poaster,
    adapter: Ecto.Adapters.Postgres
end
