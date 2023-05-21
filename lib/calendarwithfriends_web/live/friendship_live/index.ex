defmodule CalendarwithfriendsWeb.FriendshipLive.Index do
  use CalendarwithfriendsWeb, :live_view

  alias Calendarwithfriends.FriendRequests
  alias Calendarwithfriends.FriendRequests.FriendRequest
  alias Calendarwithfriends.Friendships
  alias Calendarwithfriends.Friendships.Friendship
  alias Calendarwithfriends.Accounts

  @impl true
  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])
    if connected?(socket), do: Friendships.subscribe()

    assigns = %{
      current_user: user,
      friendships: list_friendships(user.id),
      friendrequests: FriendRequests.list_friend_requests_user(user.id),
      temporary_assigns: [friendships: [], friendrequests: []],
      users: []
    }

    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Friendships")
    |> assign(:friendship, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    current_user = socket.assigns[:current_user]
    friendship = Friendships.get_friendship!(id)
    {:ok, _} = Friendships.delete_friendship(friendship)
    {:noreply, assign(socket, :friendships, list_friendships(current_user.id))}
  end

  def handle_event("search", %{"friendship" => search_query}, socket) do
    users = Accounts.list_users(search_query)
    {:noreply, assign(socket, :users, users)}
  end

  def handle_event("sendrequest", %{"id" => id}, socket) do
    current_user = socket.assigns[:current_user]
    FriendRequests.create_friend_request(%{user_id: current_user.id, pending_friend_id: id})
    {:noreply, assign(socket, :friendrequests, list_friend_requests(current_user.id))}
  end

  def handle_event("reject", %{"id" => id}, socket) do
    current_user = socket.assigns[:current_user]
    FriendRequests.delete_friend_request(%FriendRequest{:id => String.to_integer(id)})
    {:noreply, assign(socket, :friendrequests, list_friend_requests(current_user.id))}
  end

  def handle_event("accept", %{"id" => id, "userid" => userid}, socket) do
    current_user = socket.assigns[:current_user]
    FriendRequests.delete_friend_request(%FriendRequest{:id => String.to_integer(id)})
    Friendships.create_friendship(%{user_id: current_user.id, friend_id: userid})
    new_assigns = %{friendrequests: list_friend_requests(current_user.id), friendships: list_friendships(current_user.id)}
    {:noreply, assign(socket, new_assigns)}
  end

  defp list_friendships(user_id) do
    Friendships.list_friendships(%{user_id: Integer.to_string(user_id)})
  end

  defp list_friend_requests(user_id) do
    FriendRequests.list_friend_requests_user(user_id)
  end
end
