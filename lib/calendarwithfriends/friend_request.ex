defmodule Calendarwithfriends.FriendRequest do
  use Ecto.Schema

  schema "friend_requests" do
    field :message_text, :string

    belongs_to :user, Calendarwithfriends.Accounts.User
    belongs_to :friend, Calendarwithfriends.Accounts.User

    timestamps()
  end
end
