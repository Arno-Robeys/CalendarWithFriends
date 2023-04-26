defmodule CalendarwithfriendsWeb.FriendshipLiveTest do
  use CalendarwithfriendsWeb.ConnCase

  import Phoenix.LiveViewTest
  import Calendarwithfriends.FriendshipsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_friendship(_) do
    friendship = friendship_fixture()
    %{friendship: friendship}
  end

  describe "Index" do
    setup [:create_friendship]

    test "lists all friendships", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.friendship_index_path(conn, :index))

      assert html =~ "Listing Friendships"
    end

    test "saves new friendship", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.friendship_index_path(conn, :index))

      assert index_live |> element("a", "New Friendship") |> render_click() =~
               "New Friendship"

      assert_patch(index_live, Routes.friendship_index_path(conn, :new))

      assert index_live
             |> form("#friendship-form", friendship: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#friendship-form", friendship: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.friendship_index_path(conn, :index))

      assert html =~ "Friendship created successfully"
    end

    test "updates friendship in listing", %{conn: conn, friendship: friendship} do
      {:ok, index_live, _html} = live(conn, Routes.friendship_index_path(conn, :index))

      assert index_live |> element("#friendship-#{friendship.id} a", "Edit") |> render_click() =~
               "Edit Friendship"

      assert_patch(index_live, Routes.friendship_index_path(conn, :edit, friendship))

      assert index_live
             |> form("#friendship-form", friendship: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#friendship-form", friendship: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.friendship_index_path(conn, :index))

      assert html =~ "Friendship updated successfully"
    end

    test "deletes friendship in listing", %{conn: conn, friendship: friendship} do
      {:ok, index_live, _html} = live(conn, Routes.friendship_index_path(conn, :index))

      assert index_live |> element("#friendship-#{friendship.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#friendship-#{friendship.id}")
    end
  end

  describe "Show" do
    setup [:create_friendship]

    test "displays friendship", %{conn: conn, friendship: friendship} do
      {:ok, _show_live, html} = live(conn, Routes.friendship_show_path(conn, :show, friendship))

      assert html =~ "Show Friendship"
    end

    test "updates friendship within modal", %{conn: conn, friendship: friendship} do
      {:ok, show_live, _html} = live(conn, Routes.friendship_show_path(conn, :show, friendship))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Friendship"

      assert_patch(show_live, Routes.friendship_show_path(conn, :edit, friendship))

      assert show_live
             |> form("#friendship-form", friendship: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#friendship-form", friendship: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.friendship_show_path(conn, :show, friendship))

      assert html =~ "Friendship updated successfully"
    end
  end
end
