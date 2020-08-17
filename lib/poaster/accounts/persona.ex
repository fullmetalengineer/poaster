defmodule Poaster.Accounts.Persona do
  use Ecto.Schema
  import Ecto.Changeset
  alias Poaster.Accounts.User

  schema "personas" do
    belongs_to :user, User
    field :background_image_url, :string
    field :bio, :string
    field :name, :string
    field :profile_image_url, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(persona, attrs) do
    persona
    |> cast(attrs, [:username, :name, :bio, :profile_image_url, :background_image_url, :user_id])
    |> validate_required([:username])
    |> validate_min_length(:username, 2)
    |> validate_max_length(:username, 20)
    |> unique_constraint(:username, name: :personas_username_index)
  end

  def validate_min_length(changeset, field, text_length) do
    validate_change(changeset, field, fn (_current_field, value) ->
      if String.length(value) < text_length do
        [current_field: "must be at least #{text_length} characters"]
      else
        []
      end
    end)
  end

  def validate_max_length(changeset, field, text_length) do
    validate_change(changeset, field, fn (_current_field, value) ->
      if String.length(value) > text_length do
        [current_field: "must be no longer than #{text_length} characters"]
      else
        []
      end
    end)
  end
end
