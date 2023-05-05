defmodule CalendarwithfriendsWeb.FriendshipLive.UserComponent do
  use CalendarwithfriendsWeb, :live_component

  def render(assigns) do
    ~H"""
    <div id={"user-#{@user.id}"} class="bg-white shadow-lg rounded-lg px-4 py-3 mb-2">
      <div class="flex items-center justify-between">
        <div class="flex items-center">
          <div class="h-10 w-10 rounded-full bg-gray-300"></div>
          <div class="ml-4">
            <div class="font-semibold text-lg text-gray-800"><%= @user.full_name %></div>
            <div class="text-gray-500">Online</div>
          </div>
        </div>
        <%= link("Send Request",
        to: "#",
        phx_click: "sendrequest",
        phx_value_id: @user.id,
        class: "bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
          ) %>
      </div>
    </div>

    <%!--
      <%= link("Delete",
        to: "#",
        phx_click: "delete",
        phx_value_id: @user.id,
        data: [confirm: "Are you sure?"],
        class: "p-2 rounded-xl bg-slate-500 text-white hover:bg-opacity-50 shadow-md"
          ) %> --%>
    """
  end
end
