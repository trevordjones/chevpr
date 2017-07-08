defmodule Chevpr.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :first_name, :string
      add :last_name, :string
      add :password_hash, :string
      add :sign_in_count, :integer

      timestamps()
    end
    
    create unique_index(:users, [:email])
  end
end
