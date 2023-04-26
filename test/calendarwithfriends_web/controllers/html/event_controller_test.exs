defmodule CalendarwithfriendsWeb.Html.EventControllerTest do
  use CalendarwithfriendsWeb.ConnCase

  import Calendarwithfriends.EventsFixtures

  @create_attrs %{
    description: "some description",
    end_time: ~N[2023-04-24 15:06:00],
    is_private: true,
    start_time: ~N[2023-04-24 15:06:00],
    title: "some title"
  }
  @update_attrs %{
    description: "some updated description",
    end_time: ~N[2023-04-25 15:06:00],
    is_private: false,
    start_time: ~N[2023-04-25 15:06:00],
    title: "some updated title"
  }
  @invalid_attrs %{description: nil, end_time: nil, is_private: nil, start_time: nil, title: nil}

  describe "index" do
    test "lists all events", %{conn: conn} do
      conn = get(conn, Routes.html_event_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Events"
    end
  end

  describe "new event" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.html_event_path(conn, :new))
      assert html_response(conn, 200) =~ "New Event"
    end
  end

  describe "create event" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.html_event_path(conn, :create), event: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.html_event_path(conn, :show, id)

      conn = get(conn, Routes.html_event_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Event"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.html_event_path(conn, :create), event: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Event"
    end
  end

  describe "edit event" do
    setup [:create_event]

    test "renders form for editing chosen event", %{conn: conn, event: event} do
      conn = get(conn, Routes.html_event_path(conn, :edit, event))
      assert html_response(conn, 200) =~ "Edit Event"
    end
  end

  describe "update event" do
    setup [:create_event]

    test "redirects when data is valid", %{conn: conn, event: event} do
      conn = put(conn, Routes.html_event_path(conn, :update, event), event: @update_attrs)
      assert redirected_to(conn) == Routes.html_event_path(conn, :show, event)

      conn = get(conn, Routes.html_event_path(conn, :show, event))
      assert html_response(conn, 200) =~ "some updated description"
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put(conn, Routes.html_event_path(conn, :update, event), event: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Event"
    end
  end

  describe "delete event" do
    setup [:create_event]

    test "deletes chosen event", %{conn: conn, event: event} do
      conn = delete(conn, Routes.html_event_path(conn, :delete, event))
      assert redirected_to(conn) == Routes.html_event_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.html_event_path(conn, :show, event))
      end
    end
  end

  defp create_event(_) do
    event = event_fixture()
    %{event: event}
  end
end
