defmodule Calendarwithfriends.FriendRequestsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Calendarwithfriends.FriendRequests` context.
  """

  @doc """
  Generate a friend_request.
  """
  def friend_request_fixture(attrs \\ %{}) do
    {:ok, friend_request} =
      attrs
      |> Enum.into(%{
        message_text: "some message_text"
      })
      |> Calendarwithfriends.FriendRequests.create_friend_request()

    friend_request
  end
end
