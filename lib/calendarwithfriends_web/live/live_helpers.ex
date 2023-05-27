defmodule CalendarwithfriendsWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS

  @doc """
  Renders a live component inside a modal.
  
  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.
  
  ## Examples
  
      <.modal return_to={Routes.event_index_path(@socket, :index)}>
        <.live_component
          module={CalendarwithfriendsWeb.EventLive.FormComponent}
          id={@event.id || :new}
          title={@page_title}
          action={@live_action}
          return_to={Routes.event_index_path(@socket, :index)}
          event: @event
        />
      </.modal>
  """
  def modal(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)

    ~H"""
    <div id="modal" class="fixed !mt-0 inset-0 z-50 overflow-auto bg-gray-500 bg-opacity-50">
      <div class="relative mx-auto max-w-3xl my-20">
        <div class="relative bg-white rounded-md shadow-lg">
          <div class="p-6">
            <%= if @return_to do %>
              <%= live_patch("✖",
                to: @return_to,
                id: "close",
                class: "absolute top-2 right-2 text-gray-400 hover:text-gray-500 focus:outline-none",
                phx_click: hide_modal()
              ) %>
            <% else %>
              <a
                id="close"
                href="#"
                class="absolute top-2 right-2 text-gray-400 hover:text-gray-500 focus:outline-none"
                phx-click={hide_modal()}
              >
                ✖
              </a>
            <% end %>
            <%= render_slot(@inner_block) %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end
end
