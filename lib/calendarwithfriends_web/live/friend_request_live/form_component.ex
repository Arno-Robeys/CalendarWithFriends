defmodule CalendarwithfriendsWeb.FriendRequestLive.FormComponent do
  use CalendarwithfriendsWeb, :live_component

  alias Calendarwithfriends.FriendRequests

  @impl true
  def update(%{friend_request: friend_request} = assigns, socket) do
    changeset = FriendRequests.change_friend_request(friend_request)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"friend_request" => friend_request_params}, socket) do
    changeset =
      socket.assigns.friend_request
      |> FriendRequests.change_friend_request(friend_request_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"friend_request" => friend_request_params}, socket) do
    save_friend_request(socket, socket.assigns.action, friend_request_params)
  end

  defp save_friend_request(socket, :edit, friend_request_params) do
    case FriendRequests.update_friend_request(
           socket.assigns.friend_request,
           friend_request_params
         ) do
      {:ok, _friend_request} ->
        {:noreply,
         socket
         |> put_flash(:info, "Friend request updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_friend_request(socket, :new, friend_request_params) do
    case FriendRequests.create_friend_request(friend_request_params) do
      {:ok, _friend_request} ->
        {:noreply,
         socket
         |> put_flash(:info, "Friend request created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
