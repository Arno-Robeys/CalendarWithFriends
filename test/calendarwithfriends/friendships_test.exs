defmodule Calendarwithfriends.FriendshipsTest do
  use Calendarwithfriends.DataCase

  alias Calendarwithfriends.Friendships

  describe "friendships" do
    alias Calendarwithfriends.Friendships.Friendship

    import Calendarwithfriends.FriendshipsFixtures

    @invalid_attrs %{}

    test "list_friendships/0 returns all friendships" do
      friendship = friendship_fixture()
      assert Friendships.list_friendships() == [friendship]
    end

    test "get_friendship!/1 returns the friendship with given id" do
      friendship = friendship_fixture()
      assert Friendships.get_friendship!(friendship.id) == friendship
    end

    test "create_friendship/1 with valid data creates a friendship" do
      valid_attrs = %{}

      assert {:ok, %Friendship{} = friendship} = Friendships.create_friendship(valid_attrs)
    end

    test "create_friendship/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Friendships.create_friendship(@invalid_attrs)
    end

    test "update_friendship/2 with valid data updates the friendship" do
      friendship = friendship_fixture()
      update_attrs = %{}

      assert {:ok, %Friendship{} = friendship} =
               Friendships.update_friendship(friendship, update_attrs)
    end

    test "update_friendship/2 with invalid data returns error changeset" do
      friendship = friendship_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Friendships.update_friendship(friendship, @invalid_attrs)

      assert friendship == Friendships.get_friendship!(friendship.id)
    end

    test "delete_friendship/1 deletes the friendship" do
      friendship = friendship_fixture()
      assert {:ok, %Friendship{}} = Friendships.delete_friendship(friendship)
      assert_raise Ecto.NoResultsError, fn -> Friendships.get_friendship!(friendship.id) end
    end

    test "change_friendship/1 returns a friendship changeset" do
      friendship = friendship_fixture()
      assert %Ecto.Changeset{} = Friendships.change_friendship(friendship)
    end
  end
end
