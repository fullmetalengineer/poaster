defmodule Poaster.Repo.Migrations.ConvertEmailToCitext do
  use Ecto.Migration

  # How to implement case-insensitive database behavior
  # https://www.viget.com/articles/case-insensitve-string-columns-with-postgres-phoenix-and-ecto/
  # Here we want email@email.com and Email@Email.com to count as the same email
  # We do that by enabling Postgres Citext capability, which compares things downcased

  def up do
    alter table(:users) do
      modify(:email, :citext, null: false)
    end
    drop index(:users, [:email])
    create unique_index(:users, [:email])
  end

  def down do
    alter table(:users) do
      modify(:email, :string, null: false)
    end

    drop index(:users, [:email])
    create unique_index(:users, [:email])
  end
end
