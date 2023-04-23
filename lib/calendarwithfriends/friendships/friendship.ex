defmodule Calendarwithfriends.Friendships.Friendship do
  use Ecto.Schema
  import Ecto.Changeset

  schema "friendships" do
    field :user_id, :id
    field :friend_id, :id
    timestamps()
  end

  @doc false
  def changeset(friendship, attrs) do
    friendship
    |> cast(attrs, [])
    |> validate_required([])
  end
end
