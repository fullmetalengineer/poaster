defmodule Poaster.Personas.Following do
  use Ecto.Schema
  import Ecto.Changeset
  alias Poaster.Personas.Persona

  schema "followings" do
    belongs_to :persona, Persona
    belongs_to :followed, Persona

    timestamps()
  end

  @doc false
  def changeset(following, attrs) do
    following
    |> cast(attrs, [:persona_id, :followed_id])
    |> validate_required([:persona_id, :followed_id])
    |> unique_constraint([:persona_id, :followed_id], name: :followings_persona_id_followed_id_index)
  end
end
