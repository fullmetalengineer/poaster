defmodule Poaster.Repo.Migrations.CreatePersonas do
  use Ecto.Migration

  def change do
    create table(:personas) do
      add :username, :string, null: false
      add :name, :string
      add :bio, :string
      add :profile_image_url, :string
      add :background_image_url, :string
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create unique_index(:personas, [:username])
    create index(:personas, [:user_id])
  end
end
