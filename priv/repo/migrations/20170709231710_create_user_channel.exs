defmodule Chevpr.Repo.Migrations.CreateUserChannel do
  use Ecto.Migration

  def change do
    create table(:user_channels) do
      add :user_id, references(:users, on_delete: :nothing)
      add :channel_id, references(:channels, on_delete: :nothing)

      timestamps()
    end
    create index(:user_channels, [:user_id])
    create index(:user_channels, [:channel_id])

  end
end
