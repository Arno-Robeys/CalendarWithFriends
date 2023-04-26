defmodule CalendarwithfriendsWeb.FriendshipController do
  use CalendarwithfriendsWeb, :controller

  alias Calendarwithfriends.Friendships
  alias Calendarwithfriends.Friendships.Friendship

  action_fallback CalendarwithfriendsWeb.FallbackController

  def index(conn, _params) do
    friendships = Friendships.list_friendships()
    render(conn, "index.json", friendships: friendships)
  end

  def create(conn, %{"friendship" => friendship_params}) do
    with {:ok, %Friendship{} = friendship} <- Friendships.create_friendship(friendship_params) do
      conn
      |> put_status(:created)
      |> render("show.json", friendship: friendship)
    end
  end

  def show(conn, %{"id" => id}) do
    friendship = Friendships.get_friendship!(id)
    render(conn, "show.json", friendship: friendship)
  end

  def update(conn, %{"id" => id, "friendship" => friendship_params}) do
    friendship = Friendships.get_friendship!(id)

    with {:ok, %Friendship{} = friendship} <-
           Friendships.update_friendship(friendship, friendship_params) do
      render(conn, "show.json", friendship: friendship)
    end
  end

  def delete(conn, %{"id" => id}) do
    friendship = Friendships.get_friendship!(id)

    with {:ok, %Friendship{}} <- Friendships.delete_friendship(friendship) do
      send_resp(conn, :no_content, "")
    end
  end
end
