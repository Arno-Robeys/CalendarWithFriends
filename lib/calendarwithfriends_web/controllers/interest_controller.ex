defmodule CalendarwithfriendsWeb.InterestController do
  use CalendarwithfriendsWeb, :controller

  alias Calendarwithfriends.Interests
  alias Calendarwithfriends.Interests.Interest

  action_fallback CalendarwithfriendsWeb.FallbackController

  def index(conn, _params) do
    interests = Interests.list_interests()
    render(conn, "index.json", interests: interests)
  end

  def create(conn, %{"interest" => interest_params}) do
    with {:ok, %Interest{} = interest} <- Interests.create_interest(interest_params) do
      conn
      |> put_status(:created)
      |> render("show.json", interest: interest)
    end
  end

  def show(conn, %{"id" => id}) do
    interest = Interests.get_interest!(id)
    render(conn, "show.json", interest: interest)
  end

  def update(conn, %{"id" => id, "interest" => interest_params}) do
    interest = Interests.get_interest!(id)

    with {:ok, %Interest{} = interest} <- Interests.update_interest(interest, interest_params) do
      render(conn, "show.json", interest: interest)
    end
  end

  def delete(conn, %{"id" => id}) do
    interest = Interests.get_interest!(id)

    with {:ok, %Interest{}} <- Interests.delete_interest(interest) do
      send_resp(conn, :no_content, "")
    end
  end
end
