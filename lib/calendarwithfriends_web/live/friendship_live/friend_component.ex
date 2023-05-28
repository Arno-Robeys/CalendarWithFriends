defmodule CalendarwithfriendsWeb.FriendshipLive.FriendComponent do
  use CalendarwithfriendsWeb, :live_component

  def render(assigns) do
    ~H"""
    <div
      id={"friendships-#{@friendship.id}"}
      class="bg-background shadow-sm rounded-lg px-6 py-3 mb-2"
    >
      <div class="flex items-center justify-between">
        <div class="flex items-center">
          <div class="h-10 w-10 rounded-full bg-gray-300"></div>
          
          <div class="ml-4">
            <div class="font-semibold text-lg text-gray-800"><%= @full_name %></div>
            
            <div class="text-gray-500">Online</div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
