defmodule Poaster.Services.Authenticator do
  # Docs on Phoenix.Token:
  # https://hexdocs.pm/phoenix/Phoenix.Token.html
  @seed Application.get_env(:poaster, PoasterWeb.Endpoint)[:seed_token]
  @secret Application.get_env(:poaster, PoasterWeb.Endpoint)[:secret_key_base]

  def generate_token(id) do
    Phoenix.Token.sign(@secret, @seed, id)
  end
  def verify_token(token) do
    case Phoenix.Token.verify(@secret, @seed, token) do
      {:ok, id} -> {:ok, token}
      error -> error
    end
  end
end
