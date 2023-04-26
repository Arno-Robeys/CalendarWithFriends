defmodule CalendarwithfriendsWeb.Lib.CalendarComponent do
  use Phoenix.LiveComponent

  @week_start_at :monday

  def render(assigns) do
    ~H"""
    <div>
      <h1>Calendar</h1>
      <table>
        <thead>
          <tr>
          <% for week_day <- List.first(@week_rows) do %>
            <th>
              <%= week_day %>
            </th>
          <% end %>
          </tr>
        </thead>
        <tbody>
          <% for week <- @week_rows do %>
            <tr>
              <% for day <- week do %>
                <td>
                  <%= day %>
                </td>
              <% end %>
            </tr>
          <% end %>
        </tbody>
      </table>
    </div>
    """
  end

  def mount(socket) do
    current_date = Date.utc_today()

    assigns = [
      current_date: current_date,
      selected_date: nil,
      week_rows: week_rows(current_date)
    ]

    {:ok, assign(socket, assigns)}
  end

  defp week_rows(current_date) do
    first =
      current_date
      |> Date.beginning_of_month()
      |> Date.beginning_of_week(@week_start_at)

    last =
      current_date
      |> Date.end_of_month()
      |> Date.end_of_week(@week_start_at)

    Date.range(first, last)
    |> Enum.map(& &1)
    |> Enum.chunk_every(7)
  end
end
