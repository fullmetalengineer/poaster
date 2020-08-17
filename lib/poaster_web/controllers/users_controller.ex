defmodule PoasterWeb.UsersController do
  use PoasterWeb, :controller
  alias Poaster.Repo
  alias Poaster.Accounts
  alias Poaster.Accounts.User

  def me(conn, _params) do
    user = Repo.get(User, conn.assigns[:signed_user].id) |> Repo.preload([:personas])

    conn
      |> put_status(:ok)
      |> json(user_with_personas(user))
  end

  def create(conn, %{"email" => email, "phone" => phone, "password" => password}) do
    # TODO: Don't allow new accounts with the same phone number on multiple active accounts
    # We want to only allow duplicate phone numbers IFF there is no other active account with that number
    case Accounts.create_user(%{email: email, phone: phone, password: password}) do
      {:ok, user} ->
        # Log the user in using their newly created email and password
        {:ok, auth_token} = User.sign_in(email, password)
        conn
          |> put_status(:created)
          |> json(%{ success: true, data: %{ user: %{ email: user.email, phone: user.phone, token: auth_token.token }}})

      {:error, changeset} ->
        conn
          |> put_status(400)
          |> json(%{
            success: false,
            errors: %{
              detail: Poaster.Errors.full_messages(changeset)
            }
          })
    end
  end

  # def update(conn, %{"id" => id, "persona" => persona_params}) do
  #   # persona = Accounts.get_persona!(id)
  #   # result = Accounts.update_persona(persona, persona_params)

  #   # if Accounts.user_owns_persona?(conn.assigns[:signed_user], persona) do
  #   #   case result do
  #   #     {:ok, persona} ->
  #   #       conn
  #   #         |> put_status(:created)
  #   #         |> json(%{
  #   #           success: true,
  #   #           persona: persona_data(persona)
  #   #         })

  #   #     {:error, _changeset} ->
  #   #       conn
  #   #         |> put_status(:internal_server_error)
  #   #         |> json(%{
  #   #             success: false,
  #   #             error: %{
  #   #               detail: "There was an issue updating your persona. Please try again!"
  #   #             }
  #   #           })
  #   #   end
  #   # else
  #   #   action_not_allowed(conn)
  #   # end
  # end

  # def delete(conn, %{"id" => id}) do
  #   # Delete a persona
  #   # TODO: Mark as deleted, not actual delete?
  #   # user = conn.assigns[:signed_user]
  #   # persona = Accounts.get_persona!(id)

  #   # if Accounts.user_owns_persona?(user, persona) do
  #   #   result = Accounts.delete_persona(persona)
  #   #   case result do
  #   #     {:ok, %Persona{}} ->
  #   #       conn
  #   #         |> put_status(:ok)
  #   #         |> json(%{success: true})

  #   #     {:error, _changeset} ->
  #   #       conn
  #   #         |> put_status(:internal_server_error)
  #   #         |> json(%{success: false, error: %{ detail: "There was an issue deleting your persona. Please try again!"}})
  #   #     end
  #   # else
  #   #   action_not_allowed(conn)
  #   # end
  # end

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
