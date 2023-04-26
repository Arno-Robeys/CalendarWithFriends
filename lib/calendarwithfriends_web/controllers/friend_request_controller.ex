defmodule CalendarwithfriendsWeb.FriendRequestController do
  use CalendarwithfriendsWeb, :controller

  alias Calendarwithfriends.FriendRequests
  alias Calendarwithfriends.FriendRequests.FriendRequest

  action_fallback CalendarwithfriendsWeb.FallbackController

  def index(conn, _params) do
    friend_requests = FriendRequests.list_friend_requests()
    render(conn, "index.json", friend_requests: friend_requests)
  end

  def create(conn, %{"friend_request" => friend_request_params}) do
    with {:ok, %FriendRequest{} = friend_request} <-
           FriendRequests.create_friend_request(friend_request_params) do
      conn
      |> put_status(:created)
      |> render("show.json", friend_request: friend_request)
    end
  end

  def show(conn, %{"id" => id}) do
    friend_request = FriendRequests.get_friend_request!(id)
    render(conn, "show.json", friend_request: friend_request)
  end

  def update(conn, %{"id" => id, "friend_request" => friend_request_params}) do
    friend_request = FriendRequests.get_friend_request!(id)

    with {:ok, %FriendRequest{} = friend_request} <-
           FriendRequests.update_friend_request(friend_request, friend_request_params) do
      render(conn, "show.json", friend_request: friend_request)
    end
  end

  def delete(conn, %{"id" => id}) do
    friend_request = FriendRequests.get_friend_request!(id)

    with {:ok, %FriendRequest{}} <- FriendRequests.delete_friend_request(friend_request) do
      send_resp(conn, :no_content, "")
    end
  end
end
