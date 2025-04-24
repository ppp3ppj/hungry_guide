defmodule HungryGuideWeb.UnitLive.Show do
  use HungryGuideWeb, :live_view

  alias HungryGuide.Inventories

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:unit, Inventories.get_unit!(id))}
  end

  defp page_title(:show), do: "Show Unit"
  defp page_title(:edit), do: "Edit Unit"
end
