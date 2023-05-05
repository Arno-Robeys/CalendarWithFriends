defmodule CalendarwithfriendsWeb.FriendshipLive.FriendRequestComponent do
  use CalendarwithfriendsWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id={"friendrequest-#{@friendrequest.id}"}>
      <div class="flex">
        <div class="friendrequest">
          <%= @friendrequest.user_id %> sended a friend request to <%= @friendrequest.pending_friend_id %>
        </div>
        
        <div class="friendrequest__header__actions ml-auto flex items-center justify-center">
          <%= if @friendrequest.user_id == @current_user.id do %>
            <p class="mr-2">Waiting for response</p>
            
            <button
              class="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded"
              phx-click="reject"
            >
              Cancel
            </button>
          <% else %>
            <button
              class="mr-2 bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 rounded"
              phx-click="accept"
            >
              Accept
            </button>
            
            <button
              class="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded"
              phx-click="reject"
            >
              Reject
            </button>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
