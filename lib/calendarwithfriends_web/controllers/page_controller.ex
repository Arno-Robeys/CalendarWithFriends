defmodule CalendarwithfriendsWeb.PageController do
  use CalendarwithfriendsWeb, :controller

  def index(conn, _params) do
    current_date = Date.utc_today()
    assigns = %{current_date: current_date}

    render(conn, "index.html", assigns)
  end
end
