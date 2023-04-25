defmodule CalendarwithfriendsWeb.Html.FriendshipController do
  use CalendarwithfriendsWeb, :controller

  alias Calendarwithfriends.Friendships
  alias Calendarwithfriends.Friendships.Friendship

  def index(conn, _params) do
    friendships = Friendships.list_friendships()
    render(conn, "index.html", friendships: friendships)
  end

  def new(conn, _params) do
    changeset = Friendships.change_friendship(%Friendship{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"friendship" => friendship_params}) do
    case Friendships.create_friendship(friendship_params) do
      {:ok, friendship} ->
        conn
        |> put_flash(:info, "Friendship created successfully.")
        |> redirect(to: Routes.html_friendship_path(conn, :show, friendship))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    friendship = Friendships.get_friendship!(id)
    render(conn, "show.html", friendship: friendship)
  end

  def edit(conn, %{"id" => id}) do
    friendship = Friendships.get_friendship!(id)
    changeset = Friendships.change_friendship(friendship)
    render(conn, "edit.html", friendship: friendship, changeset: changeset)
  end

  def update(conn, %{"id" => id, "friendship" => friendship_params}) do
    friendship = Friendships.get_friendship!(id)

    case Friendships.update_friendship(friendship, friendship_params) do
      {:ok, friendship} ->
        conn
        |> put_flash(:info, "Friendship updated successfully.")
        |> redirect(to: Routes.html_friendship_path(conn, :show, friendship))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", friendship: friendship, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    friendship = Friendships.get_friendship!(id)
    {:ok, _friendship} = Friendships.delete_friendship(friendship)

    conn
    |> put_flash(:info, "Friendship deleted successfully.")
    |> redirect(to: Routes.html_friendship_path(conn, :index))
  end
end
