defmodule CalendarwithfriendsWeb.FriendshipView do
  use CalendarwithfriendsWeb, :view
  alias CalendarwithfriendsWeb.FriendshipView

  def render("index.json", %{friendships: friendships}) do
    %{data: render_many(friendships, FriendshipView, "friendship.json")}
  end

  def render("show.json", %{friendship: friendship}) do
    %{data: render_one(friendship, FriendshipView, "friendship.json")}
  end

  def render("friendship.json", %{friendship: friendship}) do
    %{
      id: friendship.id
    }
  end
end
