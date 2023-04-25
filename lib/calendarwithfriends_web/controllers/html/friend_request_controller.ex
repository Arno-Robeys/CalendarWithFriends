defmodule CalendarwithfriendsWeb.Html.FriendRequestController do
  use CalendarwithfriendsWeb, :controller

  alias Calendarwithfriends.FriendRequests
  alias Calendarwithfriends.FriendRequests.FriendRequest

  def index(conn, _params) do
    friend_requests = FriendRequests.list_friend_requests()
    render(conn, "index.html", friend_requests: friend_requests)
  end

  def new(conn, _params) do
    changeset = FriendRequests.change_friend_request(%FriendRequest{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"friend_request" => friend_request_params}) do
    case FriendRequests.create_friend_request(friend_request_params)
    do
      {:ok, friend_request} ->
        conn
        |> put_flash(:info, "Friend request created successfully.")
        |> redirect(to: Routes.html_friend_request_path(conn, :show, friend_request))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    friend_request = FriendRequests.get_friend_request!(id)
    render(conn, "show.html", friend_request: friend_request)
  end

  def edit(conn, %{"id" => id}) do
    friend_request = FriendRequests.get_friend_request!(id)
    changeset = FriendRequests.change_friend_request(friend_request)
    render(conn, "edit.html", friend_request: friend_request, changeset: changeset)
  end

  def update(conn, %{"id" => id, "friend_request" => friend_request_params}) do
    friend_request = FriendRequests.get_friend_request!(id)

    case FriendRequests.update_friend_request(friend_request, friend_request_params) do
      {:ok, friend_request} ->
        conn
        |> put_flash(:info, "Friend request updated successfully.")
        |> redirect(to: Routes.html_friend_request_path(conn, :show, friend_request))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", friend_request: friend_request, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    friend_request = FriendRequests.get_friend_request!(id)
    {:ok, _friend_request} = FriendRequests.delete_friend_request(friend_request)

    conn
    |> put_flash(:info, "Friend request deleted successfully.")
    |> redirect(to: Routes.html_friend_request_path(conn, :index))
  end
end
