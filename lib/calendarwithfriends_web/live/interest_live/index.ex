defmodule CalendarwithfriendsWeb.InterestLive.Index do
  use CalendarwithfriendsWeb, :live_view

  alias Calendarwithfriends.Interests
  alias Calendarwithfriends.Interests.Interest

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :interests, list_interests())}
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
end
