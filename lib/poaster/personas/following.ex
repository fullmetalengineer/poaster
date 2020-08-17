defmodule Poaster.Personas.Following do
  use Ecto.Schema
  import Ecto.Changeset
  alias Poaster.Accounts.Persona

  schema "followings" do
    belongs_to :persona, Persona
    belongs_to :follower, Follower

    timestamps()
  end

  @doc false
  def changeset(following, attrs) do
    following
    |> cast(attrs, [])
    |> validate_required([])
  end
end
