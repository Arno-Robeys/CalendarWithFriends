defmodule Calendarwithfriends.FriendRequests.FriendRequest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "friend_requests" do
    field :message_text, :string
    field :user_id, :id
    field :pending_friend_id, :id

    timestamps()
  end

  @attrs [:user_id, :pending_friend_id]
  @spec changeset(
          {map, map}
          | %{
              :__struct__ => atom | %{:__changeset__ => map, optional(any) => any},
              optional(atom) => any
            },
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: Ecto.Changeset.t()
  @doc false
  def changeset(friend_request, attrs) do
    friend_request
    |> cast(attrs, @attrs)
    |> unique_constraint(
      [:user_id, :pending_friend_id],
      name: :friend_requests_user_id_pending_friend_id_index
    )
    |> unique_constraint(
      [:pending_friend_id, :user_id],
      name: :friend_requests_pending_friend_id_user_id_index
    )
    |> validate_required([:user_id, :pending_friend_id])
    |> check_constraint(:user_id,
      name: :friend_requests_not_to_self,
      message: "You can't be friends with yourself!"
    )
  end
end
