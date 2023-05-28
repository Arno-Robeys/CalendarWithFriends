defmodule CalendarwithfriendsWeb.FriendshipLive.UserComponent do
  use CalendarwithfriendsWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id={"user-#{@user.id}"} class="bg-white shadow-md rounded-lg px-4 py-3 mb-2">
      <div class="flex items-center justify-between">
        <div class="flex items-center">
          <div class="h-10 w-10 rounded-full bg-gray-300"></div>

          <div class="ml-4">
            <div class="font-semibold text-lg text-gray-800"><%= @user.full_name %></div>

            <div class="text-gray-500">Online</div>
          </div>
        </div>

        <%= unless Enum.any?([Enum.any?(@friendships, fn {friendship, _} -> friendship.user_id == @user.id || friendship.friend_id == @user.id end), @current_user.id == @user.id]) do %>
          <%= cond do %>
            <% Enum.any?(@friendrequests, fn {friendrequest, _} -> friendrequest.pending_friend_id == @user.id end) -> %>
              <%= link("Pending Friend Request",
                  to: "#",
                  class: "bg-blue-500 hover:bg-blue-400 text-white font-bold py-2 px-4 rounded"
              ) %>

            <% Enum.any?(@friendrequests, fn {friendrequest, _} -> friendrequest.user_id == @user.id end) -> %>
              <%= link("Incoming Friend Request",
                to: "#",
                class: "bg-blue-500 hover:bg-blue-400 text-white font-bold py-2 px-4 rounded"
              ) %>

            <% true -> %>
            <%= link("Send Request",
                to: "#",
                phx_click: "sendrequest",
                phx_value_id: @user.id,
                class: "bg-blue-500 hover:bg-blue-400 text-white font-bold py-2 px-4 rounded"
              ) %>
          <% end %>
        <% end %>

        <%= if Enum.any?(@friendships, fn {friendship, _} -> (friendship.user_id == @user.id || friendship.friend_id == @user.id) && @current_user.id != @user.id end) do %>
          <%= link("Remove Friend",
            to: "#",
            phx_click: "removefriend",
            phx_value_friend: @user.id,
            class: "bg-red-500 hover:bg-red-400 text-white font-bold py-2 px-4 rounded"
          ) %>
        <% end %>
      </div>
    </div>
    """
  end
end
