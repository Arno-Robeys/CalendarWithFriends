defmodule Calendarwithfriends.Interest do
  use Ecto.Schema

  schema "interests" do
    field :id, :integer
    belongs_to :user, Calendarwithfriends.User
    belongs_to :event, Calendarwithfriends.Event
    timestamps()
  end
end
