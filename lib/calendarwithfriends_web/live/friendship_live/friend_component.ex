defmodule CalendarwithfriendsWeb.FriendshipLive.FriendComponent do
  use CalendarwithfriendsWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id={"friendships-#{@friendships.id}"}>
      @friendships.id
    </div>
    """
  end
end
