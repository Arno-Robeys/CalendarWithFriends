defmodule CalendarwithfriendsWeb.FriendRequestLive.Index do
  use CalendarwithfriendsWeb, :live_view

  alias Calendarwithfriends.FriendRequests
  alias Calendarwithfriends.FriendRequests.FriendRequest

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :friend_requests, list_friend_requests())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Friend request")
    |> assign(:friend_request, FriendRequests.get_friend_request!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Friend request")
    |> assign(:friend_request, %FriendRequest{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Friend requests")
    |> assign(:friend_request, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    friend_request = FriendRequests.get_friend_request!(id)
    {:ok, _} = FriendRequests.delete_friend_request(friend_request)

    {:noreply, assign(socket, :friend_requests, list_friend_requests())}
  end

  defp list_friend_requests do
    FriendRequests.list_friend_requests()
  end
end
