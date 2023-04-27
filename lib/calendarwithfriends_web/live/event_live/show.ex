defmodule CalendarwithfriendsWeb.EventLive.Show do
  use CalendarwithfriendsWeb, :live_view

  alias Calendarwithfriends.Events

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:event, Events.get_event!(id))
     |> assign(
       :image_link,
       "background-image: url(https://loremflickr.com/420/236/#{String.replace(Events.get_event!(id).description, " ", "")}); background-size: cover; background-position: center;"
     )}
  end

  defp page_title(:show), do: "Show Event"
  defp page_title(:edit), do: "Edit Event"
end
