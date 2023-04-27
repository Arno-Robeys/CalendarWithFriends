defmodule CalendarwithfriendsWeb.EventLive.Index do
  use CalendarwithfriendsWeb, :live_view

  alias Calendarwithfriends.Events
  alias Calendarwithfriends.Events.Event
  alias Calendarwithfriends.Accounts

  @impl true
  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])
    current_date = Date.utc_today()
    if connected?(socket), do: Events.subscribe()

    assigns = %{
      events: list_events(),
      current_date: current_date,
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
    |> assign(:page_title, "Edit Event")
    |> assign(:event, Events.get_event!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Event")
    |> assign(:event, %Event{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Events")
    |> assign(:event, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    event = Events.get_event!(id)
    {:ok, _} = Events.delete_event(event)

    {:noreply, assign(socket, :events, list_events())}
  end

  @impl true
  def handle_info({:event_created, event}, socket) do
    {:noreply, update(socket, :events, fn events -> [event | events] end)}
  end

  @impl true
  def handle_info({:event_updated, event}, socket) do
    {:noreply, update(socket, :events, fn events -> [event | events] end)}
  end

  defp list_events do
    Events.list_events()
  end
end
