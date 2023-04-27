defmodule CalendarwithfriendsWeb.EventLive.EventComponent do
  use CalendarwithfriendsWeb, :live_component

  def render(assigns) do
    ~H"""
    <tr id={"event-#{@event.id}"} class="hover:bg-slate-100">
      <td class="border-b border-slate-100 dark:border-slate-700 p-4 pl-8 text-slate-500 dark:text-black break-words">
        <%= @event.user_id %>
      </td>

      <td class="border-b border-slate-100 dark:border-slate-700 p-4 pl-8 text-slate-500 dark:text-black break-words truncate">
        <%= @event.title %>
      </td>

      <td class="border-b border-slate-100 dark:border-slate-700 p-4 pl-8 text-slate-500 dark:text-black break-words truncate">
        <%= @event.description %>
      </td>

      <td class="border-b border-slate-100 dark:border-slate-700 p-4 pl-8 text-slate-500 dark:text-black break-words">
        <%= @event.start_time %>
      </td>

      <td class="border-b border-slate-100 dark:border-slate-700 p-4 pl-8 text-slate-500 dark:text-black break-words">
        <%= @event.end_time %>
      </td>

      <td class="border-b border-slate-100 dark:border-slate-700 p-4 pl-8 text-slate-500 dark:text-black break-words">
        <%= @event.is_private %>
      </td>

      <td class="border-b border-slate-100 dark:border-slate-700 p-4 pl-8 text-slate-500 dark:text-black flex flex-col gap-4">
        <span>
          <%= live_redirect("Show",
            to: Routes.event_show_path(@socket, :show, @event),
            class: "p-2 rounded-xl bg-slate-500 text-white hover:bg-opacity-50 shadow-md"
          ) %>
        </span>
        <span>
          <%= live_patch("Edit",
            to: Routes.event_index_path(@socket, :edit, @event),
            class: "p-2 rounded-xl bg-slate-500 text-white hover:bg-opacity-50 shadow-md"
          ) %>
        </span>

        <span>
          <%= link("Delete",
            to: "#",
            phx_click: "delete",
            phx_value_id: @event.id,
            data: [confirm: "Are you sure?"],
            class: "p-2 rounded-xl bg-slate-500 text-white hover:bg-opacity-50 shadow-md"
          ) %>
        </span>
      </td>
    </tr>
    """
  end
end
