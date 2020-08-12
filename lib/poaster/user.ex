defmodule Poaster.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    has_many :auth_tokens, Poaster.AuthToken
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true
    field :phone, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :phone, :password])
    |> validate_required([:email, :phone, :password])
    |> unique_constraint(:email, downcase: true)
    |> put_password_hash()
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
        changeset
    end
  end
end
