defmodule CalendarwithfriendsWeb.MyPage do
  alias Calendarwithfriends.Accounts
  use CalendarwithfriendsWeb, :live_view

  def mount( _params , session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])
    #if connected?(socket), do: IO.puts(inspect(session))
    {:ok, assign(socket, sessie: inspect(session) , user: user.email)}
  end

    @spec render(any) :: Phoenix.LiveView.Rendered.t()
    def render(assigns) do
      ~H"""
      <div>
        <h1>Hellooooooo <%= @user %></h1>
        <br>
        ____________________________________________
        <h2 style="font-weight: bold;">Your Session:</h2>
        <p><%= inspect(assigns) %></p>
      </div>
      """
    end
  end
