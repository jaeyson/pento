defmodule Pento.Repo.Migrations.CreateUsersAuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users, comment: "Table for users") do
      add :email, :citext, null: false
      add :username, :string, size: 30, null: false
      add :name, :string, size: 50
      add :bio, :string, size: 200, comment: "user's profile description"
      add :avatar, :string, size: 70, comment: "user's profile image"
      add :status, :string, comment: "current status of a user"
      add :role, :string, comment: "user's authorization type"
      add :website, :string, size: 200
      add :hashed_password, :string, null: false
      add :confirmed_at, :naive_datetime
      timestamps()
    end

    create unique_index(:users, [:email])

    create table(:users_tokens) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:users_tokens, [:user_id])
    create unique_index(:users_tokens, [:context, :token])
    create unique_index(:users, [:username])
  end
end
