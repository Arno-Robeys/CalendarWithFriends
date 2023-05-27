defmodule Calendarwithfriends.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias Calendarwithfriends.Repo

  alias Calendarwithfriends.Events.Event
  alias Calendarwithfriends.Friendships.Friendship
  alias Calendarwithfriends.Interests.Interest

  @doc """
  Returns the list of events.
  
  ## Examples
  
      iex> list_events()
      [%Event{}, ...]
  
  """
  def list_events do
    Repo.all(from(e in Event, order_by: [asc: e.id]))
  end

  @doc """
  Returns the list of user events.
  """
  def list_user_events(id) do
    query =
      from(e in Event,
        left_join: i in assoc(e, :interests),
        left_join: u in assoc(e, :user),
        where: i.user_id == ^id or u.id == ^id,
        preload: [:interests]
      )
      |> distinct([e], e.id)

    Repo.all(query)
  end

  @doc """
  Returns the list of your friends events.
  
  """
  def list_friend_events(id) do
    query =
      from e in Event,
        join: f in Friendship,
        on: e.user_id == f.user_id or e.user_id == f.friend_id,
        where: (f.user_id == ^id or f.friend_id == ^id) and e.is_private == false,
        select: e,
        order_by: [desc: e.start_time]

    Repo.all(query)
  end

  @doc """
  Gets a single event.
  
  Raises `Ecto.NoResultsError` if the Event does not exist.
  
  ## Examples
  
      iex> get_event!(123)
      %Event{}
  
      iex> get_event!(456)
      ** (Ecto.NoResultsError)
  
  """
  def get_event!(id), do: Repo.get!(Event, id)

  @doc """
  Creates a event.
  
  ## Examples
  
      iex> create_event(%{field: value})
      {:ok, %Event{}}
  
      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:event_created)
  end

  @doc """
  Updates a event.
  
  ## Examples
  
      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}
  
      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
    |> broadcast(:event_updated)
  end

  @doc """
  Deletes a event.
  
  ## Examples
  
      iex> delete_event(event)
      {:ok, %Event{}}
  
      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}
  
  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
    |> broadcast(:event_deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.
  
  ## Examples
  
      iex> change_event(event)
      %Ecto.Changeset{data: %Event{}}
  
  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(Calendarwithfriends.PubSub, "events")
  end

  defp broadcast({:error, _reason} = error, _event) do
    error
  end

  defp broadcast({:ok, event}, broadcast_event) do
    Phoenix.PubSub.broadcast(Calendarwithfriends.PubSub, "events", {broadcast_event, event})
    {:ok, event}
  end
end
