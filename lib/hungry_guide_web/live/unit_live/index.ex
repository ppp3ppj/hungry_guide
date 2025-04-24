defmodule HungryGuideWeb.UnitLive.Index do
  use HungryGuideWeb, :live_view

  alias HungryGuide.Inventories
  alias HungryGuide.Inventories.Unit

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :units, Inventories.list_units())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Unit")
    |> assign(:unit, Inventories.get_unit!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Unit")
    |> assign(:unit, %Unit{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Units")
    |> assign(:unit, nil)
  end

  @impl true
  def handle_info({HungryGuideWeb.UnitLive.FormComponent, {:saved, unit}}, socket) do
    {:noreply, stream_insert(socket, :units, unit)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    unit = Inventories.get_unit!(id)
    {:ok, _} = Inventories.delete_unit(unit)

    {:noreply, stream_delete(socket, :units, unit)}
  end
end
