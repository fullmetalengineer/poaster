defmodule Poaster.Repo.Migrations.CreateFollowings do
  use Ecto.Migration

  def change do
    create table(:followings) do
      add :persona_id, references(:personas, on_delete: :nothing)
      add :follower_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:followings, [:persona_id])
    create index(:followings, [:follower_id])
    create index(:followings, [:persona_id, :follower_id], unique: true)
  end
end
