defmodule Calendarwithfriends.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Calendarwithfriends.Events` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        description: "some description",
        end_time: ~N[2023-04-22 15:54:00],
        is_private: true,
        start_time: ~N[2023-04-22 15:54:00],
        title: "some title"
      })
      |> Calendarwithfriends.Events.create_event()

    event
  end
end
