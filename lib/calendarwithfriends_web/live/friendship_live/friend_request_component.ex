defmodule CalendarwithfriendsWeb.FriendshipLive.FriendRequestComponent do
  use CalendarwithfriendsWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id={"friendrequest-#{@friendrequest.id}"}>
      <div class="flex pt-2 items-center justify-center bg-white px-6 py-3 rounded-s-md shadow-sm">
        <%= if @friendrequest.user_id == @current_user.id do %>
          <div class="friendrequest text-md font-medium">
            Friend Request sent to <%= @full_name %>
          </div>
        <% else %>
          <div class="friendrequest text-md font-medium">
            Friend Request from <%= @full_name %>
          </div>
        <% end %>

        <div class="friendrequest__header__actions ml-auto flex items-center justify-center">
          <%= if @friendrequest.user_id == @current_user.id do %>
            <p class="mr-2">Waiting for response</p>
            <%= link("Cancel",
              to: "#",
              phx_click: "reject",
              phx_value_id: @friendrequest.id,
              class: "bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded"
            ) %>
          <% else %>
            <%= link("Accept",
              to: "#",
              phx_click: "accept",
              phx_value_id: @friendrequest.id,
              phx_value_userid: @friendrequest.user_id,
              class: "mr-2 bg-green-500 hover:bg-green-400 text-white font-bold py-2 px-4 rounded"
            ) %> <%= link("Reject",
              to: "#",
              phx_click: "reject",
              phx_value_id: @friendrequest.id,
              class: "bg-red-500 hover:bg-red-400 text-white font-bold py-2 px-4 rounded"
            ) %>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
