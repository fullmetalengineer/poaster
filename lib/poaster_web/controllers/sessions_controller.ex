defmodule PoasterWeb.SessionsController do
  use PoasterWeb, :controller
  alias Poaster.Accounts.User
  alias Poaster.Accounts.AuthToken
  alias Poaster.Repo

  def create(conn, %{"email" => email, "password" => password}) do
    case User.sign_in(email, password) do
      {:ok, auth_token} ->
        conn
        |> put_status(:ok)
        |> json(%{
            data: %{
              token: auth_token.token
            }
          })
      {:error, reason} ->
        conn
        |> send_resp(401, reason)
    end
  end

  def delete(conn, _) do
    case User.sign_out(conn) do
      {:error, reason} -> conn |> send_resp(400, reason)
      {:ok, _} -> conn |> send_resp(204, "")
    end
  end

  def revoke(conn, %{"revoke_token" => revoke_token}) do
    token_to_revoke = Repo.get_by(AuthToken, %{token: revoke_token, user_id: conn.assigns[:signed_user].id})

    # If we didn't find the token on the user trying to delete it
    if !token_to_revoke do
      conn |> send_resp(400, "Token invalid")
    end

    case token_to_revoke
          |> Ecto.Changeset.change(%{revoked: true, revoked_at: DateTime.truncate(DateTime.utc_now, :second)})
          |> Repo.update do
      {:ok, _token} -> conn |> send_resp(204, "")
      {:error, reason} -> conn |> send_resp(400, reason)
    end
  end
end
