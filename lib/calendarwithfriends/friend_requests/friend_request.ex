defmodule Calendarwithfriends.FriendRequests.FriendRequest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "friend_requests" do
    field :message_text, :string
    field :user_id, :id
    field :pending_friend_id, :id

    timestamps()

  end

  @doc false
  def changeset(friend_request, attrs) do
    friend_request
    |> cast(attrs, [:message_text])
    |> validate_required([:message_text])
  end
end
