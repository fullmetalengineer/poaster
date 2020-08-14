defmodule PoasterWeb.PersonasController do
  use PoasterWeb, :controller
  alias Poaster.Accounts
  alias Poaster.Accounts.Persona

  def show(conn, %{"id" => id}) do
    persona = Accounts.get_persona!(id)
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
    result = Accounts.create_persona(%{username: username, user_id: user.id})
    IO.inspect(result)
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
          |> json(%{
              success: false,
              error: %{
                detail: message
              }
            })
    end
  end

  def update(conn, %{"id" => id, "persona" => persona_params}) do
    persona = Accounts.get_persona!(id)
    result = Accounts.update_persona(persona, persona_params)

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
  end

  def delete(conn, %{"id" => id}) do
    # Delete a persona
    # TODO: Mark as deleted, not actual delete?
    persona = Accounts.get_persona!(id)
    result = Accounts.delete_persona(persona)

    case result do
      {:ok, %Persona{}} ->
        conn
          |> put_status(:ok)
          |> json(%{success: true})

      {:error, _changeset} ->
        conn
          |> put_status(:internal_server_error)
          |> json(%{
              success: false,
              error: %{
                detail: "There was an issue deleting your persona. Please try again!"
              }
            })
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
end
