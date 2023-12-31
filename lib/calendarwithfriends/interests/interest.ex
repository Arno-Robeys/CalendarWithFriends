defmodule Calendarwithfriends.Interests.Interest do
  use Ecto.Schema
  import Ecto.Changeset

  alias Calendarwithfriends.Accounts.User
  alias Calendarwithfriends.Events.Event

  schema "interests" do
    belongs_to :user, User
    belongs_to :event, Event
    timestamps()
  end

  @doc false
  def changeset(interest, attrs) do
    interest
    |> cast(attrs, [:event_id, :user_id])
    |> validate_required([:event_id, :user_id])
  end
end
