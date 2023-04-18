defmodule Calendarwithfriends.Friendship do
  use Ecto.Schema

  schema "friendships" do
    belongs_to :user, Calendarwithfriends.Accounts.User
    belongs_to :friend, Calendarwithfriends.Accounts.User

    timestamps()
  end
end
