defmodule CalendarwithfriendsWeb.FriendshipLive.Index do
  use CalendarwithfriendsWeb, :live_view

  alias Calendarwithfriends.Friendships
  alias Calendarwithfriends.Friendships.Friendship
  alias Calendarwithfriends.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :friendships, list_friendships())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Friendship")
    |> assign(:friendship, Friendships.get_friendship!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Friendship")
    |> assign(:friendship, %Friendship{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Friendships")
    |> assign(:friendship, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    friendship = Friendships.get_friendship!(id)
    {:ok, _} = Friendships.delete_friendship(friendship)

    {:noreply, assign(socket, :friendships, list_friendships())}
  end

  def handle_event("search", %{"friendship" => search_query}, socket) do
    users = Accounts.list_users(search_query)
    {:noreply, assign(socket, :users, users)}
  end

  defp list_friendships do
    Friendships.list_friendships()
  end
end
