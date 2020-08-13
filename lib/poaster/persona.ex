defmodule Poaster.Persona do
  use Ecto.Schema
  import Ecto.Changeset
  alias Poaster.User

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
    |> cast(attrs, [:username, :name, :bio, :profile_image_url, :background_image_url])
    |> validate_required([:username])
    |> unique_constraint(:username)
  end
end
