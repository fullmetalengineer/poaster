defmodule PoasterWeb.FollowingsController do
  use PoasterWeb, :controller
  alias Poaster.Personas
  alias Poaster.Personas.Persona
  alias Poaster.Repo

  def index(conn, %{"current_persona_id" => current_persona_id}) do
    persona = Personas.get_persona!(current_persona_id) |> Repo.preload([followings: [:followed]])
    case persona do
      %Persona{} ->
        conn
        |> put_status(:ok)
        |> json(%{
          follows: Enum.map(persona.followings, fn follow ->
            IO.inspect(follow)
            %{
              id: follow.id,
              followed_id: follow.followed_id,
              inserted_at: follow.inserted_at,
              followed_persona_details: %{
                name: follow.followed.name,
                username: follow.followed.username,
                profile_image_url: follow.followed.profile_image_url,
                bio: follow.followed.bio
              }
            }
          end)
        })
    end
  end

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, %{"current_persona_id" => current_persona_id, "persona_id" => persona_id}) do
    signed_in_persona = Personas.get_persona!(current_persona_id) |> Poaster.Repo.preload([followings: [:followed]])
    # Get the list of ID's of the people the signed_in_persona follows
    followed_ids = Enum.map(signed_in_persona.followings, fn f -> f.followed_id end)

    # If the persona the signed_in_persona is trying to follow is already followed...
    if persona_id in followed_ids do
      # User already follows this user
      conn
        |> put_status(:created)
        |> json(%{
          success: true
        })
    else
      result = Personas.create_following(%{persona_id: signed_in_persona.id, followed_id: persona_id})
      case result do
        {:ok, _following} ->
          conn
            |> put_status(:created)
            |> json(%{success: true})

        {:error, _changeset} ->
          conn
            |> put_status(:internal_server_error)
            |> json(%{success: false, error: %{detail: "Error following that persona!"}})
      end
    end
  end

  def delete(conn, %{"current_persona_id" => current_persona_id, "id" => following_id}) do
    following_id = String.to_integer(following_id)
    signed_in_persona = Personas.get_persona!(current_persona_id) |> Poaster.Repo.preload([followings: [:followed]])
    # Get the list of ID's of the people the signed_in_persona follows
    follow_ids = Enum.map(signed_in_persona.followings, fn f -> f.id end)

    if following_id in follow_ids do
      # Get the following record
      following = Personas.get_following!(following_id)
      # Delete the following record
      result = Personas.delete_following(following)
      case result do
        {:ok, _following} ->
          conn
            |> put_status(:ok)
            |> json(%{success: true})

        {:error, _changeset} ->
          conn
            |> put_status(:internal_server_error)
            |> json(%{success: false, error: %{detail: "Error unfollowing that persona!"}})
      end
    else
      # Signed in persona doesn't follow that persona anyways
      conn
        |> put_status(:created)
        |> json(%{success: true})
    end
  end
end
