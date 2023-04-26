defmodule Calendarwithfriends.FriendRequestsTest do
  use Calendarwithfriends.DataCase

  alias Calendarwithfriends.FriendRequests

  describe "friend_requests" do
    alias Calendarwithfriends.FriendRequests.FriendRequest

    import Calendarwithfriends.FriendRequestsFixtures

    @invalid_attrs %{message_text: nil}

    test "list_friend_requests/0 returns all friend_requests" do
      friend_request = friend_request_fixture()
      assert FriendRequests.list_friend_requests() == [friend_request]
    end

    test "get_friend_request!/1 returns the friend_request with given id" do
      friend_request = friend_request_fixture()
      assert FriendRequests.get_friend_request!(friend_request.id) == friend_request
    end

    test "create_friend_request/1 with valid data creates a friend_request" do
      valid_attrs = %{message_text: "some message_text"}

      assert {:ok, %FriendRequest{} = friend_request} =
               FriendRequests.create_friend_request(valid_attrs)

      assert friend_request.message_text == "some message_text"
    end

    test "create_friend_request/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FriendRequests.create_friend_request(@invalid_attrs)
    end

    test "update_friend_request/2 with valid data updates the friend_request" do
      friend_request = friend_request_fixture()
      update_attrs = %{message_text: "some updated message_text"}

      assert {:ok, %FriendRequest{} = friend_request} =
               FriendRequests.update_friend_request(friend_request, update_attrs)

      assert friend_request.message_text == "some updated message_text"
    end

    test "update_friend_request/2 with invalid data returns error changeset" do
      friend_request = friend_request_fixture()

      assert {:error, %Ecto.Changeset{}} =
               FriendRequests.update_friend_request(friend_request, @invalid_attrs)

      assert friend_request == FriendRequests.get_friend_request!(friend_request.id)
    end

    test "delete_friend_request/1 deletes the friend_request" do
      friend_request = friend_request_fixture()
      assert {:ok, %FriendRequest{}} = FriendRequests.delete_friend_request(friend_request)

      assert_raise Ecto.NoResultsError, fn ->
        FriendRequests.get_friend_request!(friend_request.id)
      end
    end

    test "change_friend_request/1 returns a friend_request changeset" do
      friend_request = friend_request_fixture()
      assert %Ecto.Changeset{} = FriendRequests.change_friend_request(friend_request)
    end
  end
end
