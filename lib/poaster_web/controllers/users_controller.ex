defmodule PoasterWeb.UsersController do
  use PoasterWeb, :controller
  alias Poaster.Repo
  alias Poaster.Accounts.User

  def me(conn, _params) do
    user = Repo.get(User, conn.assigns[:signed_user].id) |> Repo.preload([:personas])

    conn
      |> put_status(:ok)
      |> json(user_with_personas(user))
  end

  defp user_with_personas(user) do
    %{
      data: %{
        user: %{
          email: user.email,
          phone: user.phone,
          personas: Enum.map(user.personas, fn persona ->
            %{
              id: persona.id,
              background_image_url: persona.background_image_url,
              bio: persona.bio,
              inserted_at: persona.inserted_at,
              name: persona.name,
              profile_image_url: persona.profile_image_url,
              updated_at: persona.updated_at,
              username: persona.username
            }
          end)
        }
      }
    }
  end
end
