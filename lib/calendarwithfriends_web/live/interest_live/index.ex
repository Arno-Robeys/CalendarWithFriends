defmodule CalendarwithfriendsWeb.InterestLive.Index do
  use CalendarwithfriendsWeb, :live_view

  alias Calendarwithfriends.Interests
  alias Calendarwithfriends.Accounts
  alias Calendarwithfriends.Events

  @impl true
  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])
    if connected?(socket), do: Events.subscribe()

    assigns = %{
      interests: list_interests(user.id),
      events: list_public_events(user.id),
      current_user: user,
      temporary_assigns: [events: []]
    }

    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Interests")
    |> assign(:interest, nil)
  end

  def handle_event("create_interest", %{"id" => id}, socket) do
    Interests.create_interest(%{event_id: id, user_id: socket.assigns.current_user.id})
    {:noreply, assign(socket, :interests, list_interests(socket.assigns.current_user.id))}
  end

  @impl true
  def handle_event("delete_interest", %{"id" => id}, socket) do
    interest = Interests.get_interest_eventid!(id, socket.assigns.current_user.id)
    {:ok, _} = Interests.delete_interest(interest)

    {:noreply, assign(socket, :interests, list_interests(socket.assigns.current_user.id))}
  end

  defp list_interests(userid) do
    Interests.list_interests_by_user(userid)
  end

  defp list_public_events(id) do
    Events.list_friend_events(id)
  end
end
