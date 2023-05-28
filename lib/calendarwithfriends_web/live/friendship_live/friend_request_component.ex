defmodule CalendarwithfriendsWeb.FriendshipLive.FriendRequestComponent do
  use CalendarwithfriendsWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id={"friendrequest-#{@friendrequest.id}"}>
      <div class="min-[320px]:flex pt-2 items-center justify-between bg-white px-6 py-3 rounded-s-md shadow-sm">
        <%= if @friendrequest.user_id == @current_user.id do %>
          <div class="friendrequest text-md font-medium">
            Friend Request sent to <%= @full_name %>
          </div>
        <% else %>
          <div class="friendrequest text-md font-medium">
            Friend Request from <%= @full_name %>
          </div>
        <% end %>
        
        <div class="friendrequest__header__actions min-[320px]:flex gap-2 items-center justify-center min-[320px]:ml-6">
          <%= if @friendrequest.user_id == @current_user.id do %>
            <div class="hidden sm:flex gap-1">
              <div class="w-2 h-2 rounded-full bg-gray-400"></div>
              
              <div class="w-2 h-2 rounded-full bg-gray-400"></div>
              
              <div class="w-2 h-2 rounded-full bg-gray-400"></div>
            </div>
            
            <%!--alternative <button phx-click="reject" phx-value-id={@friendrequest.id} class="inline-block bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded">Cancel</button> --%> <%= link(
              "Cancel",
              to: "#",
              phx_click: "reject",
              phx_value_id: @friendrequest.id,
              class: "inline-block bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded"
            ) %>
          <% else %>
            <%= link("Accept",
              to: "#",
              phx_click: "accept",
              phx_value_id: @friendrequest.id,
              phx_value_userid: @friendrequest.user_id,
              class:
                "inline-block bg-green-500 hover:bg-green-400 text-white font-bold py-2 px-4 rounded"
            ) %> <%= link("Reject",
              to: "#",
              phx_click: "reject",
              phx_value_id: @friendrequest.id,
              class: "inline-block bg-red-500 hover:bg-red-400 text-white font-bold py-2 px-4 rounded"
            ) %>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
