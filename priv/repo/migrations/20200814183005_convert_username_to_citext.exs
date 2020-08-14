defmodule Poaster.Repo.Migrations.ConvertUsernameToCitext do
  use Ecto.Migration

  # How to implement case-insensitive database behavior
  # https://www.viget.com/articles/case-insensitve-string-columns-with-postgres-phoenix-and-ecto/
  # Here we want TacticalMinivan and tacticalminivan to count as the same username
  # We do that by enabling Postgres Citext capability, which compares things downcased

  def up do
    execute "CREATE EXTENSION citext"

    alter table(:personas) do
      modify(:username, :citext, null: false)
    end
    drop index(:personas, [:username])
    create unique_index(:personas, [:username])
  end

  def down do
    alter table(:personas) do
      modify(:username, :string, null: false)
    end

    drop index(:personas, [:username])
    create unique_index(:personas, [:username])

    execute "DROP EXTENSION citext"
  end
end
