defmodule PoasterWeb.UserController do
  use PoasterWeb, :controller
  alias Poaster.User

  def me(conn, _params) do
    u = Poaster.Repo.get(Poaster.User, conn.assigns[:signed_user].id) |> Poaster.Repo.preload([:personas])

    conn
      |> put_status(:ok)
      |> json(%{
        data: %{
          user: %{
            email: u.email,
            phone: u.phone,
            personas: Enum.map(u.personas, fn persona ->
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
      })
  end
end
