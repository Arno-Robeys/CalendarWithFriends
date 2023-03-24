defmodule CalendarwithfriendsWeb.PageController do
  use CalendarwithfriendsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
