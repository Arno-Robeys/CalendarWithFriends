defmodule Calendarwithfriends.Event do
  use Ecto.Schema

  schema "events" do
    field :id, :integer
    field :title, :string
    field :description, :string
    field :start_time, :datetime
    field :end_time, :datetime
    field :is_private, :boolean, default: true

    belongs_to :user, Calendarwithfriends.Accounts.User
    has_many :interests, Calendarwithfriends.Interest

    timestamps()
  end
end
