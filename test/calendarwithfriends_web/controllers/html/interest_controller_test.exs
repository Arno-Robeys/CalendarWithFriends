defmodule CalendarwithfriendsWeb.Html.InterestControllerTest do
  use CalendarwithfriendsWeb.ConnCase

  import Calendarwithfriends.InterestsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all interests", %{conn: conn} do
      conn = get(conn, Routes.html_interest_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Interests"
    end
  end

  describe "new interest" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.html_interest_path(conn, :new))
      assert html_response(conn, 200) =~ "New Interest"
    end
  end

  describe "create interest" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.html_interest_path(conn, :create), interest: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.html_interest_path(conn, :show, id)

      conn = get(conn, Routes.html_interest_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Interest"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.html_interest_path(conn, :create), interest: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Interest"
    end
  end

  describe "edit interest" do
    setup [:create_interest]

    test "renders form for editing chosen interest", %{conn: conn, interest: interest} do
      conn = get(conn, Routes.html_interest_path(conn, :edit, interest))
      assert html_response(conn, 200) =~ "Edit Interest"
    end
  end

  describe "update interest" do
    setup [:create_interest]

    test "redirects when data is valid", %{conn: conn, interest: interest} do
      conn = put(conn, Routes.html_interest_path(conn, :update, interest), interest: @update_attrs)
      assert redirected_to(conn) == Routes.html_interest_path(conn, :show, interest)

      conn = get(conn, Routes.html_interest_path(conn, :show, interest))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, interest: interest} do
      conn = put(conn, Routes.html_interest_path(conn, :update, interest), interest: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Interest"
    end
  end

  describe "delete interest" do
    setup [:create_interest]

    test "deletes chosen interest", %{conn: conn, interest: interest} do
      conn = delete(conn, Routes.html_interest_path(conn, :delete, interest))
      assert redirected_to(conn) == Routes.html_interest_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.html_interest_path(conn, :show, interest))
      end
    end
  end

  defp create_interest(_) do
    interest = interest_fixture()
    %{interest: interest}
  end
end
