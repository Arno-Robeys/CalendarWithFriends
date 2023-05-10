defmodule Calendarwithfriends.Repo.Migrations.CreateFriendRequests do
  use Ecto.Migration

  def change do
    create table(:friend_requests) do
      add :user_id, references(:users)
      add :pending_friend_id, references(:users)
      timestamps()
    end

    create index(:friend_requests, [:user_id])

    create unique_index(
             :friend_requests,
             [:user_id, :pending_friend_id],
             name: :friend_requests_user_id_pending_friend_id_index
           )

    create unique_index(
             :friend_requests,
             [:pending_friend_id, :user_id],
             name: :friend_requests_pending_friend_id_user_id_index
           )

    create constraint(:friend_requests, :friend_requests_not_to_self,
             check: """
               user_id <> pending_friend_id
             """
           )
  end
end
