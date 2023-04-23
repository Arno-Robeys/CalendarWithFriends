defmodule Calendarwithfriends.Repo.Migrations.CreateFriendships do
  use Ecto.Migration

  def change do
    create table(:friendships) do
      add :user_id, references(:users)
      add :friend_id, references(:friend_requests)

      timestamps()
    end
    create unique_index(:friendships, [:user_id, :friend_id])
  end
end
