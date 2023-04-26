defmodule CalendarwithfriendsWeb.InterestLive.FormComponent do
  use CalendarwithfriendsWeb, :live_component

  alias Calendarwithfriends.Interests

  @impl true
  def update(%{interest: interest} = assigns, socket) do
    changeset = Interests.change_interest(interest)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"interest" => interest_params}, socket) do
    changeset =
      socket.assigns.interest
      |> Interests.change_interest(interest_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"interest" => interest_params}, socket) do
    save_interest(socket, socket.assigns.action, interest_params)
  end

  defp save_interest(socket, :edit, interest_params) do
    case Interests.update_interest(socket.assigns.interest, interest_params) do
      {:ok, _interest} ->
        {:noreply,
         socket
         |> put_flash(:info, "Interest updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_interest(socket, :new, interest_params) do
    case Interests.create_interest(interest_params) do
      {:ok, _interest} ->
        {:noreply,
         socket
         |> put_flash(:info, "Interest created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
