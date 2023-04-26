defmodule CalendarwithfriendsWeb.FriendRequestLiveTest do
  use CalendarwithfriendsWeb.ConnCase

  import Phoenix.LiveViewTest
  import Calendarwithfriends.FriendRequestsFixtures

  @create_attrs %{message_text: "some message_text"}
  @update_attrs %{message_text: "some updated message_text"}
  @invalid_attrs %{message_text: nil}

  defp create_friend_request(_) do
    friend_request = friend_request_fixture()
    %{friend_request: friend_request}
  end

  describe "Index" do
    setup [:create_friend_request]

    test "lists all friend_requests", %{conn: conn, friend_request: friend_request} do
      {:ok, _index_live, html} = live(conn, Routes.friend_request_index_path(conn, :index))

      assert html =~ "Listing Friend requests"
      assert html =~ friend_request.message_text
    end

    test "saves new friend_request", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.friend_request_index_path(conn, :index))

      assert index_live |> element("a", "New Friend request") |> render_click() =~
               "New Friend request"

      assert_patch(index_live, Routes.friend_request_index_path(conn, :new))

      assert index_live
             |> form("#friend_request-form", friend_request: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#friend_request-form", friend_request: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.friend_request_index_path(conn, :index))

      assert html =~ "Friend request created successfully"
      assert html =~ "some message_text"
    end

    test "updates friend_request in listing", %{conn: conn, friend_request: friend_request} do
      {:ok, index_live, _html} = live(conn, Routes.friend_request_index_path(conn, :index))

      assert index_live
             |> element("#friend_request-#{friend_request.id} a", "Edit")
             |> render_click() =~
               "Edit Friend request"

      assert_patch(index_live, Routes.friend_request_index_path(conn, :edit, friend_request))

      assert index_live
             |> form("#friend_request-form", friend_request: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#friend_request-form", friend_request: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.friend_request_index_path(conn, :index))

      assert html =~ "Friend request updated successfully"
      assert html =~ "some updated message_text"
    end

    test "deletes friend_request in listing", %{conn: conn, friend_request: friend_request} do
      {:ok, index_live, _html} = live(conn, Routes.friend_request_index_path(conn, :index))

      assert index_live
             |> element("#friend_request-#{friend_request.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#friend_request-#{friend_request.id}")
    end
  end

  describe "Show" do
    setup [:create_friend_request]

    test "displays friend_request", %{conn: conn, friend_request: friend_request} do
      {:ok, _show_live, html} =
        live(conn, Routes.friend_request_show_path(conn, :show, friend_request))

      assert html =~ "Show Friend request"
      assert html =~ friend_request.message_text
    end

    test "updates friend_request within modal", %{conn: conn, friend_request: friend_request} do
      {:ok, show_live, _html} =
        live(conn, Routes.friend_request_show_path(conn, :show, friend_request))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Friend request"

      assert_patch(show_live, Routes.friend_request_show_path(conn, :edit, friend_request))

      assert show_live
             |> form("#friend_request-form", friend_request: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#friend_request-form", friend_request: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.friend_request_show_path(conn, :show, friend_request))

      assert html =~ "Friend request updated successfully"
      assert html =~ "some updated message_text"
    end
  end
end
