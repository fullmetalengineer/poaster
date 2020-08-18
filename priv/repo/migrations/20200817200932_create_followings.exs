defmodule Poaster.Repo.Migrations.CreateFollowings do
  use Ecto.Migration

  def change do
    create table(:followings) do
      add :persona_id, references(:personas, on_delete: :nothing)
      add :followed_id, references(:personas, on_delete: :nothing)

      timestamps()
    end

    create index(:followings, [:persona_id])
    create index(:followings, [:followed_id])
    create index(:followings, [:persona_id, :followed_id], unique: true)
  end
end
