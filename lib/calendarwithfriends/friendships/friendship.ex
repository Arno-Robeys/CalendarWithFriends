defmodule Calendarwithfriends.Friendships.Friendship do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

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

  @doc """
  A friendship search on user_id.
  """
  def search(query, user_id) do
    from(friendship in query,
      where: friendship.user_id == ^user_id
    )
  end
end
