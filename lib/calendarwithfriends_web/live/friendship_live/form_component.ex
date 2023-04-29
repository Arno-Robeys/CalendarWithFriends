defmodule CalendarwithfriendsWeb.FriendshipLive.FormComponent do
  use CalendarwithfriendsWeb, :live_component

  alias Calendarwithfriends.Friendships

  @impl true
  def update(%{friendship: friendship} = assigns, socket) do
    changeset = Friendships.change_friendship(friendship)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"friendship" => friendship_params}, socket) do
    changeset =
      socket.assigns.friendship
      |> Friendships.change_friendship(friendship_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"friendship" => friendship_params}, socket) do
    save_friendship(socket, socket.assigns.action, friendship_params)
  end

  defp save_friendship(socket, :edit, friendship_params) do
    case Friendships.update_friendship(socket.assigns.friendship, friendship_params) do
      {:ok, _friendship} ->
        {:noreply,
         socket
         |> put_flash(:info, "Friendship updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_friendship(socket, :new, friendship_params) do
    case Friendships.create_friendship(friendship_params) do
      {:ok, _friendship} ->
        {:noreply,
         socket
         |> put_flash(:info, "Friendship created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
