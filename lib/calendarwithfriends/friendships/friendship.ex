defmodule Calendarwithfriends.Friendships.Friendship do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query, warn: false

  alias Calendarwithfriends.Accounts.User

  schema "friendships" do
    field :user_id, :id
    field :friend_id, :id
    timestamps()
  end

  @doc false
  def changeset(friendship, attrs) do
    friendship
    |> cast(attrs, [:friend_id, :user_id])
    |> validate_required([:friend_id, :user_id])
  end

  @doc """
  A friendship search on user_id.
  """
  def search(query, user_id) do
    user_id = String.to_integer(user_id)

    from(f in query,
      join: u in User,
      on:
        fragment(
          "CASE WHEN ? = ? THEN ? = ? ELSE ? = ? END",
          ^user_id,
          f.friend_id,
          u.id,
          f.user_id,
          u.id,
          f.friend_id
        ),
      where: f.user_id == ^user_id or f.friend_id == ^user_id,
      select: {f, u.full_name}
    )
  end
end
