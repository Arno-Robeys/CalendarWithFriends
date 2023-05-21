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

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Friend requests")
    |> assign(:friend_request, nil)
  end

  defp list_friend_requests do
    FriendRequests.list_friend_requests()
  end
end
