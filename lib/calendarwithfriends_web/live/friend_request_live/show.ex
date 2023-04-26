defmodule CalendarwithfriendsWeb.FriendRequestLive.Show do
  use CalendarwithfriendsWeb, :live_view

  alias Calendarwithfriends.FriendRequests

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:friend_request, FriendRequests.get_friend_request!(id))}
  end

  defp page_title(:show), do: "Show Friend request"
  defp page_title(:edit), do: "Edit Friend request"
end
