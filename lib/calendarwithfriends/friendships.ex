defmodule Calendarwithfriends.Friendships do
  @moduledoc """
  The Friendships context.
  """

  import Ecto.Query, warn: false
  alias Calendarwithfriends.Repo

  alias Calendarwithfriends.Friendships.Friendship

  @doc """
  Returns the list of friendships.
  
  ## Examples
  
      iex> list_friendships()
      [%Friendship{}, ...]
  
  """
  def list_friendships do
    Repo.all(from(f in Friendship, order_by: [asc: f.id]))
  end

  @doc """
  Returns the list of friendships based on user_id.
  
  ## Examples
  
      iex> list_friendships()
      [%Friendship{}, ...]
  
  """
  def list_friendships(params) do
    IO.inspect(params, label: "params")

    user_id =
      case params[:user_id] do
        nil ->
          raise "Missing user_id parameter"

        user_id ->
          user_id
      end

    Friendship
    |> Friendship.search(user_id)
    |> Repo.all()
  end

  @doc """
  Gets a single friendship.
  
  Raises `Ecto.NoResultsError` if the Friendship does not exist.
  
  ## Examples
  
      iex> get_friendship!(123)
      %Friendship{}
  
      iex> get_friendship!(456)
      ** (Ecto.NoResultsError)
  
  """
  def get_friendship!(id), do: Repo.get!(Friendship, id)

  @doc """
  Creates a friendship.
  
  ## Examples
  
      iex> create_friendship(%{field: value})
      {:ok, %Friendship{}}
  
      iex> create_friendship(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def create_friendship(attrs \\ %{}) do
    %Friendship{}
    |> Friendship.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:friendship_created)
  end

  @doc """
  Updates a friendship.
  
  ## Examples
  
      iex> update_friendship(friendship, %{field: new_value})
      {:ok, %Friendship{}}
  
      iex> update_friendship(friendship, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def update_friendship(%Friendship{} = friendship, attrs) do
    friendship
    |> Friendship.changeset(attrs)
    |> Repo.update()
    |> broadcast(:friendship_updated)
  end

  @doc """
  Deletes a friendship.
  
  ## Examples
  
      iex> delete_friendship(friendship)
      {:ok, %Friendship{}}
  
      iex> delete_friendship(friendship)
      {:error, %Ecto.Changeset{}}
  
  """
  def delete_friendship(%Friendship{} = friendship) do
    Repo.delete(friendship)
    |> broadcast(:friendship_deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking friendship changes.
  
  ## Examples
  
      iex> change_friendship(friendship)
      %Ecto.Changeset{data: %Friendship{}}
  
  """
  def change_friendship(%Friendship{} = friendship, attrs \\ %{}) do
    Friendship.changeset(friendship, attrs)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Calendarwithfriends.PubSub, "friendships")
  end

  defp broadcast({:error, _reason} = error, _friendship) do
    error
  end

  defp broadcast({:ok, friendship}, broadcast_friendship) do
    Phoenix.PubSub.broadcast(
      Calendarwithfriends.PubSub,
      "friendships",
      {broadcast_friendship, friendship}
    )

    {:ok, friendship}
  end
end
