defmodule Poaster.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Poaster.Repo

  alias Poaster.Accounts.User
  alias Poaster.Accounts.Persona

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Determines if a user owns a particular personas.

  ## Examples

      iex> user_owns_persona?(user, persona)
      true

      iex> user_owns_persona?(user, persona)
      false

  """
  def user_owns_persona?(user, persona) do
    user_with_personas = user |> Repo.preload(:personas)

    # # Filter down using a comprehension to get a match
    # a = []
    # for p <- user_with_personas.personas, p.id == persona.id, into: a, do: p

    # Determine if the persona passed in is in the returned list
    persona in user_with_personas.personas
  end

  @doc """
  Returns the number of personas a user has on their account

  ## Examples

      iex> persona_count(user)
      3

  """
  def persona_count(user) do
    user |> Ecto.assoc(:personas) |> Repo.aggregate(:count, :id)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end


  @doc """
  Returns the list of personas.

  ## Examples

      iex> list_personas()
      [%Persona{}, ...]

  """
  def list_personas do
    Repo.all(Persona)
  end

  @doc """
  Gets a single persona.

  Raises `Ecto.NoResultsError` if the Persona does not exist.

  ## Examples

      iex> get_persona!(123)
      %Persona{}

      iex> get_persona!(456)
      ** (Ecto.NoResultsError)

  """
  def get_persona!(id), do: Repo.get!(Persona, id)

  @spec create_persona(
          :invalid
          | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: any
  @doc """
  Creates a persona.

  ## Examples

      iex> create_persona(%{field: value})
      {:ok, %Persona{}}

      iex> create_persona(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_persona(attrs \\ %{}) do
    %Persona{}
    |> Persona.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a persona.

  ## Examples

      iex> update_persona(persona, %{field: new_value})
      {:ok, %User{}}

      iex> update_persona(persona, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_persona(%Persona{} = persona, attrs) do
    # Don't allow users to change these fields:
    attrs = Map.drop(attrs, ["username", "inserted_at", "updated_at"])

    persona
    |> Persona.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a persona.

  ## Examples

      iex> delete_persona(persona)
      {:ok, %Persona{}}

      iex> delete_persona(persona)
      {:error, %Ecto.Changeset{}}

  """
  def delete_persona(%Persona{} = persona) do
    Repo.delete(persona)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking persona changes.

  ## Examples

      iex> change_persona(persona)
      %Ecto.Changeset{data: %Persona{}}

  """
  def change_persona(%Persona{} = persona, attrs \\ %{}) do
    Persona.changeset(persona, attrs)
  end
end
