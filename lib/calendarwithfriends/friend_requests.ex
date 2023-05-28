defmodule Calendarwithfriends.FriendRequests do
  @moduledoc """
  The FriendRequests context.
  """

  import Ecto.Query, warn: false
  alias Calendarwithfriends.Repo

  alias Calendarwithfriends.FriendRequests.FriendRequest
  alias Calendarwithfriends.Repo
  alias Calendarwithfriends.Accounts.User

  @doc """
  Returns the list of friend_requests.
  
  ## Examples
  
      iex> list_friend_requests()
      [%FriendRequest{}, ...]
  
  """
  def list_friend_requests do
    Repo.all(FriendRequest)
  end

  def list_friend_requests_user(user_id) do
    Repo.all(
      from(friend_request in FriendRequest,
        join: u in User,
        on:
          fragment(
            "CASE WHEN ? = ? THEN ? = ? ELSE ? = ? END",
            ^user_id,
            friend_request.pending_friend_id,
            u.id,
            friend_request.user_id,
            u.id,
            friend_request.pending_friend_id
          ),
        where: friend_request.user_id == ^user_id or friend_request.pending_friend_id == ^user_id,
        select: {friend_request, u.full_name}
      )
    )
  end

  @doc """
  Gets a single friend_request.
  
  Raises `Ecto.NoResultsError` if the Friend request does not exist.
  
  ## Examples
  
      iex> get_friend_request!(123)
      %FriendRequest{}
  
      iex> get_friend_request!(456)
      ** (Ecto.NoResultsError)
  
  """
  def get_friend_request!(id), do: Repo.get!(FriendRequest, id)

  @doc """
  Creates a friend_request.
  
  ## Examples
  
      iex> create_friend_request(%{field: value})
      {:ok, %FriendRequest{}}
  
      iex> create_friend_request(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def create_friend_request(attrs \\ %{}) do
    %FriendRequest{}
    |> FriendRequest.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:friend_request_created)
  end

  @doc """
  Updates a friend_request.
  
  ## Examples
  
      iex> update_friend_request(friend_request, %{field: new_value})
      {:ok, %FriendRequest{}}
  
      iex> update_friend_request(friend_request, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def update_friend_request(%FriendRequest{} = friend_request, attrs) do
    friend_request
    |> FriendRequest.changeset(attrs)
    |> Repo.update()
    |> broadcast(:friend_request_updated)
  end

  @doc """
  Deletes a friend_request.
  
  ## Examples
  
      iex> delete_friend_request(friend_request)
      {:ok, %FriendRequest{}}
  
      iex> delete_friend_request(friend_request)
      {:error, %Ecto.Changeset{}}
  
  """
  def delete_friend_request(%FriendRequest{} = friend_request) do
    Repo.delete(friend_request)
    |> broadcast(:friend_request_deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking friend_request changes.
  
  ## Examples
  
      iex> change_friend_request(friend_request)
      %Ecto.Changeset{data: %FriendRequest{}}
  
  """
  def change_friend_request(%FriendRequest{} = friend_request, attrs \\ %{}) do
    FriendRequest.changeset(friend_request, attrs)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Calendarwithfriends.PubSub, "friend_requests")
  end

  defp broadcast({:error, _reason} = error, _friend_request) do
    error
  end

  defp broadcast({:ok, friend_request}, broadcast_friend_request) do
    Phoenix.PubSub.broadcast(
      Calendarwithfriends.PubSub,
      "friend_requests",
      {broadcast_friend_request, friend_request}
    )

    {:ok, friend_request}
  end
end
