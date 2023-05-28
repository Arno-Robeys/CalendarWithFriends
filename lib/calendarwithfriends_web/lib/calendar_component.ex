defmodule CalendarwithfriendsWeb.Lib.CalendarComponent do
  use Phoenix.LiveComponent

  @week_start_at :monday

  def render(assigns) do
    ~H"""
    <div class="bg-white rounded-lg shadow overflow-hidden">
      <div class="flex items-center justify-between py-2 px-6">
        <div>
          <span class="text-lg font-bold text-gray-800">
            <%= Calendar.strftime(@current_date, "%B") %>
          </span>

          <span class="ml-1 text-lg text-gray-600 font-normal">
            <%= Calendar.strftime(@current_date, "%Y") %>
          </span>
        </div>

        <div class="border rounded-lg px-1">
          <button
            class="leading-none rounded-lg transition ease-in-out duration-100 inline-flex cursor-pointer hover:bg-gray-200 p-1 items-center"
            type="button"
            phx-target={@myself}
            phx-click="prev-month"
          >
            <svg
              class="h-6 w-6 text-gray-500 inline-flex leading-none"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M15 19l-7-7 7-7"
              >
              </path>
            </svg>
          </button>

          <div class="border-r inline-flex h-6"></div>

          <button
            class="leading-none rounded-lg transition ease-in-out duration-100 inline-flex items-center cursor-pointer hover:bg-gray-200 p-1"
            type="button"
            phx-target={@myself}
            phx-click="next-month"
          >
            <svg
              class="h-6 w-6 text-gray-500 inline-flex leading-none"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7">
              </path>
            </svg>
          </button>
        </div>
      </div>

      <table class="table-fixed border-t w-full">
        <thead>
          <tr class="h-20">
            <%= for week_day <- List.first(@week_rows) do %>
              <th>
                <%= Calendar.strftime(week_day, "%a") %>
              </th>
            <% end %>
          </tr>
        </thead>

        <tbody>
          <%= for week <- @week_rows do %>
            <tr>
              <%= for day <- week do %>
                <td class={
                  [
                    "text-center",
                    today?(day) && "bg-green-100",
                    other_month?(day, @current_date) && "bg-gray-100",
                    "hover:bg-blue-100",
                    "h-80 text-center border-r border-b px-4 pt-2"
                  ]
                }>
                  <button
                    class="w-full h-full relative"
                    type="button"
                    phx-target={@myself}
                    phx-click="pick-date"
                    phx-value-date={Calendar.strftime(day, "%Y-%m-%d")}
                  >
                    <time class="absolute top-0 left-0" datetime={Calendar.strftime(day, "%Y-%m-%d")}>
                      <%= Calendar.strftime(day, "%d") %>
                    </time>

                    <div
                      class="h-full flex flex-wrap content-start gap-1 pt-12"
                      phx-update="replace"
                      id="events"
                    >
                      <%= for event <- events_on_day(@events, day) do %>
                        <div>
                          <div
                            class="w-6 h-6 rounded-full bg-no-repeat bg-center bg-cover group relative"
                            style="background-image: url('https://source.unsplash.com/user/c_v_r/48x48');"
                            id:
                            event.id,
                            event:
                            event
                          >
                            <%= live_redirect("........",
                              to: @routes.event_show_path(@socket, :show, event),
                              class: "w-6 h-6 opacity-0"
                            ) %>
                            <div class="text-black invisible group-hover:visible absolute left-6 bottom-8 z-20 w-80 text-left p-4 rounded-md bg-slate-50 break-words">
                              <ul>
                                <li>title: <%= event.title %></li>

                                <li>description: <%= event.description %></li>

                                <li>start_time: <%= event.start_time %></li>

                                <li>end_time: <%= event.end_time %></li>
                              </ul>
                            </div>
                          </div>
                        </div>
                      <% end %>
                    </div>
                  </button>
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

  def handle_event("prev-month", _, socket) do
    new_date = socket.assigns.current_date |> Date.beginning_of_month() |> Date.add(-1)

    assigns = [
      current_date: new_date,
      week_rows: week_rows(new_date)
    ]

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("next-month", _, socket) do
    new_date = socket.assigns.current_date |> Date.end_of_month() |> Date.add(1)

    assigns = [
      current_date: new_date,
      week_rows: week_rows(new_date)
    ]

    {:noreply, assign(socket, assigns)}
  end

  def handle_event("pick-date", %{"date" => date}, socket) do
    {:noreply, assign(socket, :selected_date, Date.from_iso8601!(date))}
  end

  defp selected_date?(day, selected_date), do: day == selected_date

  defp today?(day), do: day == Date.utc_today()

  defp other_month?(day, current_date),
    do: Date.beginning_of_month(day) != Date.beginning_of_month(current_date)

  defp events_on_day(events, day) do
    Enum.filter(events, fn event ->
      {:ok, date_struct} =
        Date.from_erl({Map.get(day, :year), Map.get(day, :month), Map.get(day, :day)})

      NaiveDateTime.to_date(event.start_time) == date_struct
    end)
  end
end
