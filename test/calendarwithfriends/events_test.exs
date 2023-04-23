defmodule Calendarwithfriends.EventsTest do
  use Calendarwithfriends.DataCase

  alias Calendarwithfriends.Events

  describe "events" do
    alias Calendarwithfriends.Events.Event

    import Calendarwithfriends.EventsFixtures

    @invalid_attrs %{description: nil, end_time: nil, is_private: nil, start_time: nil, title: nil}

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Events.list_events() == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Events.get_event!(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      valid_attrs = %{description: "some description", end_time: ~N[2023-04-22 15:54:00], is_private: true, start_time: ~N[2023-04-22 15:54:00], title: "some title"}

      assert {:ok, %Event{} = event} = Events.create_event(valid_attrs)
      assert event.description == "some description"
      assert event.end_time == ~N[2023-04-22 15:54:00]
      assert event.is_private == true
      assert event.start_time == ~N[2023-04-22 15:54:00]
      assert event.title == "some title"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Events.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      update_attrs = %{description: "some updated description", end_time: ~N[2023-04-23 15:54:00], is_private: false, start_time: ~N[2023-04-23 15:54:00], title: "some updated title"}

      assert {:ok, %Event{} = event} = Events.update_event(event, update_attrs)
      assert event.description == "some updated description"
      assert event.end_time == ~N[2023-04-23 15:54:00]
      assert event.is_private == false
      assert event.start_time == ~N[2023-04-23 15:54:00]
      assert event.title == "some updated title"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Events.update_event(event, @invalid_attrs)
      assert event == Events.get_event!(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Events.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Events.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Events.change_event(event)
    end
  end
end
