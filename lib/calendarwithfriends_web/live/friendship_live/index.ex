defmodule CalendarwithfriendsWeb.FriendshipLive.Index do
  use CalendarwithfriendsWeb, :live_view

  alias Calendarwithfriends.FriendRequests
  alias Calendarwithfriends.FriendRequests.FriendRequest
  alias Calendarwithfriends.Friendships
  alias Calendarwithfriends.Accounts

  @impl true
  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])
    if connected?(socket), do: Friendships.subscribe()
    if connected?(socket), do: FriendRequests.subscribe()

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

    new_assigns = %{
      friendrequests: list_friend_requests(current_user.id),
      friendships: list_friendships(current_user.id)
    }

    {:noreply, assign(socket, new_assigns)}
  end

  def handle_event("accept", %{"id" => id, "userid" => userid}, socket) do
    current_user = socket.assigns[:current_user]
    FriendRequests.delete_friend_request(%FriendRequest{:id => String.to_integer(id)})
    Friendships.create_friendship(%{user_id: current_user.id, friend_id: userid})

    new_assigns = %{
      friendrequests: list_friend_requests(current_user.id),
      friendships: list_friendships(current_user.id)
    }

    {:noreply, assign(socket, new_assigns)}
  end

  def handle_event("removefriend", %{"friend" => friend_id}, socket) do
    current_user = socket.assigns[:current_user]

    friendshipsOfOtherUser = list_friendships(elem(Integer.parse(friend_id), 0))

    filtered_friendships =
      Enum.filter(friendshipsOfOtherUser, fn {friendship, _} ->
        friendship.user_id == current_user.id || friendship.friend_id == current_user.id
      end)

    Enum.each(filtered_friendships, fn {friendship, _} ->
      Friendships.delete_friendship(Friendships.get_friendship!(friendship.id))
    end)

    # Friendships.delete_friendship(%{user_id: current_user.id, friend_id: friend_id})
    {:noreply, assign(socket, :friendships, list_friendships(current_user.id))}
  end

  defp list_friendships(user_id) do
    Friendships.list_friendships(%{user_id: Integer.to_string(user_id)})
  end

  defp filter_friend_requests_on_current_user(friendshipsOfOtherUser) do
  end

  defp list_friend_requests(user_id) do
    FriendRequests.list_friend_requests_user(user_id)
  end

  # broadcasts
  @impl true
  def handle_info({:friendship_created, friendship}, socket) do
    {:noreply, update(socket, :friendships, list_friendships(socket.assigns[:current_user].id))}
  end

  @impl true
  def handle_info({:friendship_deleted, friendship}, socket) do
    {:noreply, update(socket, :friendships, list_friendships(socket.assigns[:current_user].id))}
  end

  @impl true
  def handle_info({:friendship_updated, friendship}, socket) do
    {:noreply, update(socket, :friendships, list_friendships(socket.assigns[:current_user].id))}
  end

  @impl true
  def handle_info({:friend_request_created, friend_request}, socket) do
    {:noreply,
     update(socket, :friend_requests, list_friend_requests(socket.assigns[:current_user].id))}
  end

  @impl true
  def handle_info({:friend_request_deleted, friend_request}, socket) do
    {:noreply,
     update(socket, :friend_requests, list_friend_requests(socket.assigns[:current_user].id))}
  end

  @impl true
  def handle_info({:friend_request_updated, friend_request}, socket) do
    {:noreply,
     update(socket, :friend_requests, list_friend_requests(socket.assigns[:current_user].id))}
  end
end
