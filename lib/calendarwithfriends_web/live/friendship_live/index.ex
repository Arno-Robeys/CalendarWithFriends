defmodule CalendarwithfriendsWeb.FriendshipLive.Index do
  use CalendarwithfriendsWeb, :live_view

  alias Calendarwithfriends.Friendships
  alias Calendarwithfriends.Friendships.Friendship
  alias Calendarwithfriends.Accounts

  @impl true
  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])
    if connected?(socket), do: Friendships.subscribe()

    assigns = %{
      current_user: user,
      temporary_assigns: [friendships: []],
      friendships: list_friendships()
    }

    {:ok, assign(socket, assigns)}
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

  defp list_friendships do
    Friendships.list_friendships()
  end
end
