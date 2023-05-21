defmodule CalendarwithfriendsWeb.InterestLive.Index do
  use CalendarwithfriendsWeb, :live_view

  alias Calendarwithfriends.Interests
  alias Calendarwithfriends.Interests.Interest
  alias Calendarwithfriends.Accounts
  alias Calendarwithfriends.Events
  alias Calendarwithfriends.Events.Event

  @impl true
  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])
    if connected?(socket), do: Events.subscribe()

    assigns = %{
      interests: list_interests(),
      events: list_public_events(),
      current_user: user,
      temporary_assigns: [events: []]
    }

    {:ok, assign(socket, assigns)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Interest")
    |> assign(:interest, Interests.get_interest!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Interest")
    |> assign(:interest, %Interest{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Interests")
    |> assign(:interest, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    interest = Interests.get_interest!(id)
    {:ok, _} = Interests.delete_interest(interest)

    {:noreply, assign(socket, :interests, list_interests())}
  end

  defp list_interests do
    Interests.list_interests()
  end

  defp list_events do
    Events.list_events()
  end

  defp list_public_events do
    list_events()
    |> Enum.filter(fn event -> event.is_private == false end)
  end
end
