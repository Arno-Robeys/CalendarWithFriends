defmodule CalendarwithfriendsWeb.FriendshipLive.FriendComponent do
  use CalendarwithfriendsWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id={"friendships-#{@friendship.id}"}>
      You're friends with <%= @friendship.friend_id %>
    </div>
    """
  end
end
