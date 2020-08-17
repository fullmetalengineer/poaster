defmodule PoasterWeb.PersonasController do
  use PoasterWeb, :controller
  alias Poaster.Accounts
  alias Poaster.Personas
  alias Poaster.Personas.Persona
  alias Poaster.Repo

  def availability(conn, %{"username" => username}) do
    # Guard against empty usernames
    if String.length(username) < 1 do
      conn |> put_status(400) |> json(%{ available: false})
    else
      # TODO: Require usernames to be a certain length?
      persona = Repo.get_by(Persona, username: username)

      case persona do
        %Persona{} ->
          conn
            |> put_status(400)
            |> json(%{ available: false})
        nil ->
          conn
          |> put_status(200)
          |> json(%{ available: true })
      end
    end
  end

  def show(conn, %{"id" => id}) do
    persona = Personas.get_persona!(id)
    case persona do
      %Persona{} ->
        conn
        |> put_status(:ok)
        |> json(persona_data(persona))
      # Ecto.NoResultsError ->
      #   conn
      #   |> put_status(:not_found)
      #   |> json(%{ data: %{error: %{ detail: "Persona not found"}}})
    end
  end

  def create(conn, %{"username" => username}) do
    user = conn.assigns[:signed_user]

    # Handle having a limit on persona creation
    if Accounts.persona_count(user) >= 3 do
      conn
      |> put_status(400)
      |> json(%{ success: false, error:
        %{ detail: "You have reached your persona limit. Please purchase additional personas if you wish to create more!"}
        })
      |> halt
    else
      # Guard against empty usernames
      if String.length(username) < 1 do
        conn
          |> put_status(400)
          |> json(%{ success: false, error: %{ detail: "You must provide a valid username when creating a Persona!" }})
          |> halt()
      else
        result = Personas.create_persona(%{username: username, user_id: user.id})
        case result do
          {:ok, persona} ->
            conn
              |> put_status(:created)
              |> json(%{
                  success: true,
                  persona: persona_data(persona)
              })
          {:error, changeset} ->
            message = if (changeset.errors[:username]), do: "That username is already taken!", else: "There was an error creating that username!"
            conn
              |> put_status(:internal_server_error)
              |> json(%{success: false, error: %{detail: message}})
        end
      end
    end
  end

  def update(conn, %{"id" => id, "persona" => persona_params}) do
    persona = Personas.get_persona!(id)
    result = Personas.update_persona(persona, persona_params)

    if Accounts.user_owns_persona?(conn.assigns[:signed_user], persona) do
      case result do
        {:ok, persona} ->
          conn
            |> put_status(:created)
            |> json(%{
              success: true,
              persona: persona_data(persona)
            })

        {:error, _changeset} ->
          conn
            |> put_status(:internal_server_error)
            |> json(%{
                success: false,
                error: %{
                  detail: "There was an issue updating your persona. Please try again!"
                }
              })
      end
    else
      action_not_allowed(conn)
    end
  end

  def delete(conn, %{"id" => id}) do
    # Delete a persona
    # TODO: Mark as deleted, not actual delete?
    user = conn.assigns[:signed_user]
    persona = Personas.get_persona!(id)

    if Accounts.user_owns_persona?(user, persona) do
      result = Personas.delete_persona(persona)
      case result do
        {:ok, %Persona{}} ->
          conn
            |> put_status(:ok)
            |> json(%{success: true})

        {:error, _changeset} ->
          conn
            |> put_status(:internal_server_error)
            |> json(%{success: false, error: %{ detail: "There was an issue deleting your persona. Please try again!"}})
        end
    else
      action_not_allowed(conn)
    end
  end

  defp persona_data(persona) do
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
  end

  defp action_not_allowed(conn) do
    conn
        |> put_status(:bad_request)
        |> json(%{ success: false, error: %{ detail: "You are not allowed to perform this action" }})
  end
end
