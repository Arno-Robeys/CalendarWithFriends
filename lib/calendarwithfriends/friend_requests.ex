defmodule Calendarwithfriends.FriendRequests do
  @moduledoc """
  The FriendRequests context.
  """

  import Ecto.Query, warn: false
  alias Calendarwithfriends.Repo

  alias Calendarwithfriends.FriendRequests.FriendRequest

  @doc """
  Returns the list of friend_requests.

  ## Examples

      iex> list_friend_requests()
      [%FriendRequest{}, ...]

  """
  def list_friend_requests do
    Repo.all(FriendRequest)
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
end
