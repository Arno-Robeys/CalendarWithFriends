defmodule CalendarwithfriendsWeb.FriendRequestView do
  use CalendarwithfriendsWeb, :view
  alias CalendarwithfriendsWeb.FriendRequestView

  def render("index.json", %{friend_requests: friend_requests}) do
    %{data: render_many(friend_requests, FriendRequestView, "friend_request.json")}
  end

  def render("show.json", %{friend_request: friend_request}) do
    %{data: render_one(friend_request, FriendRequestView, "friend_request.json")}
  end

  def render("friend_request.json", %{friend_request: friend_request}) do
    %{
      id: friend_request.id,
      message_text: friend_request.message_text
    }
  end
end
