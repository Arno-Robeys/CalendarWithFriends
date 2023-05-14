defmodule CalendarwithfriendsWeb.Lib.FeedComponent do
  use Phoenix.LiveComponent
  import Timex

  @week_start_at :monday

  def render(assigns) do
    ~H"""
    <div id="events">
      <%= for event <- @events do %>
        <div id={"event-#{event.id}"}>
          <div class="mt-10">
            <div class="bg-white rounded-3xl shadow-xl">
              <div class="p-4 sm:p-6 space-y-2">
                <ul>
                  <li>
                    <%= to_string(
                      elem(
                        Timex.format(event.start_time, "%a, %d %b %Y %H:%M:%S %z", :strftime),
                        1
                      )
                    ) %>
                  </li>
                  
                  <li class="text-lg font-semibold leading-none">
                    <%= event.title %>
                  </li>
                  
                  <li class="text-md font-semibold text-gray-500 leading-none">
                    <%= event.description %>
                  </li>
                  
                  <li class="relative">
                    <button class="bg-blue-500 text-white px-4 py-2 rounded-full absolute top-0 right-0 transform -translate-y-full">
                      <%= if true do %>
                        Interest
                      <% else %>
                        Interested
                      <% end %>
                    </button>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  def mount(socket) do
    current_date = Date.utc_today()

    assigns = [
      current_date: current_date
    ]

    {:ok, assign(socket, assigns)}
  end
end
