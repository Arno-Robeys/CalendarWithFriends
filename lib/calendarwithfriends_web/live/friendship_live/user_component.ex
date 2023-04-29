defmodule CalendarwithfriendsWeb.FriendshipLive.UserComponent do
  use CalendarwithfriendsWeb, :live_component

  def render(assigns) do
    ~H"""
    <tr id={"user-#{@user.id}"} class="hover:bg-slate-100">
      <td class="border-b border-slate-100 dark:border-slate-700 p-4 pl-8 text-slate-500 dark:text-black break-words">
        <%= @user.id %>
      </td>

      <td class="border-b border-slate-100 dark:border-slate-700 p-4 pl-8 text-slate-500 dark:text-black break-words">
        <%= @user.full_name %>
      </td>

      <%!-- <td class="border-b border-slate-100 dark:border-slate-700 p-4 pl-8 text-slate-500 dark:text-black flex flex-col gap-4">
        <span>
          <%= link("Delete",
            to: "#",
            phx_click: "delete",
            phx_value_id: @user.id,
            data: [confirm: "Are you sure?"],
            class: "p-2 rounded-xl bg-slate-500 text-white hover:bg-opacity-50 shadow-md"
          ) %>
        </span>
      </td> --%>
    </tr>
    """
  end
end
