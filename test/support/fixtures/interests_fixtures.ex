defmodule Calendarwithfriends.InterestsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Calendarwithfriends.Interests` context.
  """

  @doc """
  Generate a interest.
  """
  def interest_fixture(attrs \\ %{}) do
    {:ok, interest} =
      attrs
      |> Enum.into(%{

      })
      |> Calendarwithfriends.Interests.create_interest()

    interest
  end
end
