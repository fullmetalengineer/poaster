defmodule Poaster.Services.Authenticator do
  # Docs on Phoenix.Token:
  # https://hexdocs.pm/phoenix/Phoenix.Token.html
  @seed Application.get_env(:poaster, PoasterWeb.Endpoint)[:seed_token]
  @secret Application.get_env(:poaster, PoasterWeb.Endpoint)[:secret_key_base]

  def generate_token(id) do
    # TODO: Figure out how to do long-lasting tokens, or convert to generating my own using the below:
    # :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length)
    Phoenix.Token.sign(@secret, @seed, id)
  end
  def verify_token(token) do
    case Phoenix.Token.verify(@secret, @seed, token) do
      {:ok, _id} -> {:ok, token}
      error -> error
    end
  end

  def get_auth_token(conn) do
    case extract_token(conn) do
      {:ok, token} -> verify_token(token)
      error -> error
    end
  end

  defp extract_token(conn) do
    case Plug.Conn.get_req_header(conn, "authorization") do
      [auth_header] -> get_token_from_header(auth_header)
       _ -> {:error, :missing_auth_header}
    end
  end

  defp get_token_from_header(auth_header) do
    {:ok, reg} = Regex.compile("Bearer\:?\s+(.*)$", "i")
    case Regex.run(reg, auth_header) do
      [_, match] -> {:ok, String.trim(match)}
      _ -> {:error, "token not found"}
    end
  end
end
