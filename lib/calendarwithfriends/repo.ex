defmodule Calendarwithfriends.Repo do
  use Ecto.Repo,
    otp_app: :calendarwithfriends,
    adapter: Ecto.Adapters.Postgres
end
