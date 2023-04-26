defmodule CalendarwithfriendsWeb.FriendshipControllerTest do
  use CalendarwithfriendsWeb.ConnCase

  import Calendarwithfriends.FriendshipsFixtures

  alias Calendarwithfriends.Friendships.Friendship

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all friendships", %{conn: conn} do
      conn = get(conn, Routes.friendship_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create friendship" do
    test "renders friendship when data is valid", %{conn: conn} do
      conn = post(conn, Routes.friendship_path(conn, :create), friendship: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.friendship_path(conn, :show, id))

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.friendship_path(conn, :create), friendship: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update friendship" do
    setup [:create_friendship]

    test "renders friendship when data is valid", %{
      conn: conn,
      friendship: %Friendship{id: id} = friendship
    } do
      conn =
        put(conn, Routes.friendship_path(conn, :update, friendship), friendship: @update_attrs)

      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.friendship_path(conn, :show, id))

      assert %{
               "id" => ^id
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, friendship: friendship} do
      conn =
        put(conn, Routes.friendship_path(conn, :update, friendship), friendship: @invalid_attrs)

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete friendship" do
    setup [:create_friendship]

    test "deletes chosen friendship", %{conn: conn, friendship: friendship} do
      conn = delete(conn, Routes.friendship_path(conn, :delete, friendship))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.friendship_path(conn, :show, friendship))
      end
    end
  end

  defp create_friendship(_) do
    friendship = friendship_fixture()
    %{friendship: friendship}
  end
end
