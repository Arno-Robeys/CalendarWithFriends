defmodule CalendarwithfriendsWeb.EventLive.FormComponent do
  use CalendarwithfriendsWeb, :live_component

  alias Calendarwithfriends.Events

  @impl true
  def update(%{event: event} = assigns, socket) do
    changeset = Events.change_event(event)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"event" => event_params}, socket) do
    changeset =
      socket.assigns.event
      |> Events.change_event(event_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"event" => event_params}, socket) do
    save_event(socket, socket.assigns.action, event_params)
  end

  defp save_event(socket, :edit, event_params) do
    case Events.update_event(socket.assigns.event, event_params) do
      {:ok, _event} ->
        {:noreply,
         socket
         |> put_flash(:info, "Event updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_event(socket, :new, event_params) do
    case Events.create_event(event_params) do
      {:ok, _event} ->
        {:noreply,
         socket
         |> put_flash(:info, "Event created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def my_datetime_select(form, field, opts \\ []) do
    current_date = DateTime.utc_now()

    default_opts = %{
      day: current_date.day,
      month: current_date.month,
      year: current_date.year,
      hour: current_date.hour,
      minute: current_date.minute
    }

    builder = fn b ->
      assigns = %{b: b}

      ~H"""
      <div class="flex items-center space-x-2 w-">
        <%= @b.(:day, class: "w-20 py-2 px-3 rounded border-gray-300") %>
        <span>/</span> <%= @b.(:month, class: "w-32 py-2 px-3 rounded border-gray-300") %>
        <span>/</span> <%= @b.(:year, class: "w-28 py-2 px-3 rounded border-gray-300") %>
        <span class="mx-2">-</span> <%= @b.(:hour, class: "w-20 py-2 px-3 rounded border-gray-300") %>
        <span>:</span> <%= @b.(:minute, class: "w-20 py-2 px-3 rounded border-gray-300") %>
      </div>
      """
    end

    datetime_select(form, field, [builder: builder, default: default_opts] ++ opts)
  end
end
