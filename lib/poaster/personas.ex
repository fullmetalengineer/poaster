defmodule Poaster.Personas do
  @moduledoc """
  The Personas context.
  """

  import Ecto.Query, warn: false
  alias Poaster.Repo
  alias Poaster.Personas.Persona
  alias Poaster.Personas.Following


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

  @doc """
  Returns the list of followings.

  ## Examples

      iex> list_followings()
      [%Following{}, ...]

  """
  def list_followings do
    Repo.all(Following)
  end

  @doc """
  Gets a single following.

  Raises `Ecto.NoResultsError` if the Following does not exist.

  ## Examples

      iex> get_following!(123)
      %Following{}

      iex> get_following!(456)
      ** (Ecto.NoResultsError)

  """
  def get_following!(id), do: Repo.get!(Following, id)

  @doc """
  Creates a following.

  ## Examples

      iex> create_following(%{field: value})
      {:ok, %Following{}}

      iex> create_following(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_following(attrs \\ %{}) do
    %Following{}
    |> Following.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a following.

  ## Examples

      iex> update_following(following, %{field: new_value})
      {:ok, %Following{}}

      iex> update_following(following, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_following(%Following{} = following, attrs) do
    following
    |> Following.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a following.

  ## Examples

      iex> delete_following(following)
      {:ok, %Following{}}

      iex> delete_following(following)
      {:error, %Ecto.Changeset{}}

  """
  def delete_following(%Following{} = following) do
    Repo.delete(following)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking following changes.

  ## Examples

      iex> change_following(following)
      %Ecto.Changeset{data: %Following{}}

  """
  def change_following(%Following{} = following, attrs \\ %{}) do
    Following.changeset(following, attrs)
  end
end
