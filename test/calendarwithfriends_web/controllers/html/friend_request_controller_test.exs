defmodule CalendarwithfriendsWeb.Html.FriendRequestControllerTest do
  use CalendarwithfriendsWeb.ConnCase

  import Calendarwithfriends.FriendRequestsFixtures

  @create_attrs %{message_text: "some message_text"}
  @update_attrs %{message_text: "some updated message_text"}
  @invalid_attrs %{message_text: nil}

  describe "index" do
    test "lists all friend_requests", %{conn: conn} do
      conn = get(conn, Routes.html_friend_request_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Friend requests"
    end
  end

  describe "new friend_request" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.html_friend_request_path(conn, :new))
      assert html_response(conn, 200) =~ "New Friend request"
    end
  end

  describe "create friend_request" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.html_friend_request_path(conn, :create), friend_request: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.html_friend_request_path(conn, :show, id)

      conn = get(conn, Routes.html_friend_request_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Friend request"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.html_friend_request_path(conn, :create), friend_request: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Friend request"
    end
  end

  describe "edit friend_request" do
    setup [:create_friend_request]

    test "renders form for editing chosen friend_request", %{conn: conn, friend_request: friend_request} do
      conn = get(conn, Routes.html_friend_request_path(conn, :edit, friend_request))
      assert html_response(conn, 200) =~ "Edit Friend request"
    end
  end

  describe "update friend_request" do
    setup [:create_friend_request]

    test "redirects when data is valid", %{conn: conn, friend_request: friend_request} do
      conn = put(conn, Routes.html_friend_request_path(conn, :update, friend_request), friend_request: @update_attrs)
      assert redirected_to(conn) == Routes.html_friend_request_path(conn, :show, friend_request)

      conn = get(conn, Routes.html_friend_request_path(conn, :show, friend_request))
      assert html_response(conn, 200) =~ "some updated message_text"
    end

    test "renders errors when data is invalid", %{conn: conn, friend_request: friend_request} do
      conn = put(conn, Routes.html_friend_request_path(conn, :update, friend_request), friend_request: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Friend request"
    end
  end

  describe "delete friend_request" do
    setup [:create_friend_request]

    test "deletes chosen friend_request", %{conn: conn, friend_request: friend_request} do
      conn = delete(conn, Routes.html_friend_request_path(conn, :delete, friend_request))
      assert redirected_to(conn) == Routes.html_friend_request_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.html_friend_request_path(conn, :show, friend_request))
      end
    end
  end

  defp create_friend_request(_) do
    friend_request = friend_request_fixture()
    %{friend_request: friend_request}
  end
end
