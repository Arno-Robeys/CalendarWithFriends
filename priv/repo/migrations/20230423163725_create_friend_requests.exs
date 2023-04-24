defmodule Calendarwithfriends.Repo.Migrations.CreateFriendRequests do
  use Ecto.Migration

  def change do
    create table(:friend_requests) do
      add :message_text, :string
      add :user_id, references(:users)
      add :pending_friend_id, references(:users)
      timestamps()
    end
    create unique_index(:friend_requests, [:user_id, :pending_friend_id])
  end
end
