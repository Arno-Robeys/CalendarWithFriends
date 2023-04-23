defmodule Calendarwithfriends.FriendshipsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Calendarwithfriends.Friendships` context.
  """

  @doc """
  Generate a friendship.
  """
  def friendship_fixture(attrs \\ %{}) do
    {:ok, friendship} =
      attrs
      |> Enum.into(%{

      })
      |> Calendarwithfriends.Friendships.create_friendship()

    friendship
  end
end
