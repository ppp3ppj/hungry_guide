defmodule HungryGuideWeb.IngredientLive.Show do
  use HungryGuideWeb, :live_view

  alias HungryGuide.Inventories

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    ingredient = Inventories.get_ingredient!(id)

    units = Inventories.list_units()
      |> Enum.map(&{&1.name, &1.id})

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:ingredient, ingredient)
     |> assign(:units, units)}
  end

  defp page_title(:show), do: "Show Ingredient"
  defp page_title(:edit), do: "Edit Ingredient"
end
