defmodule HungryGuideWeb.IngredientLive.Index do
  use HungryGuideWeb, :live_view

  alias HungryGuide.Inventories
  alias HungryGuide.Inventories.Ingredient

  @impl true
  def mount(_params, _session, socket) do
    units = Inventories.list_units()
      |> Enum.map(&{&1.name, &1.id})

    socket =
      socket
      |> assign(:units, units)
      |> stream(:ingredients, Inventories.list_ingredients())

    {:ok, socket}
    #{:ok, stream(socket, :ingredients, Inventories.list_ingredients())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Ingredient")
    |> assign(:ingredient, Inventories.get_ingredient!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Ingredient")
    |> assign(:ingredient, %Ingredient{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Ingredients")
    |> assign(:ingredient, nil)
  end

  @impl true
  def handle_info({HungryGuideWeb.IngredientLive.FormComponent, {:saved, ingredient}}, socket) do
    {:noreply, stream_insert(socket, :ingredients, ingredient)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    ingredient = Inventories.get_ingredient!(id)
    {:ok, _} = Inventories.delete_ingredient(ingredient)

    {:noreply, stream_delete(socket, :ingredients, ingredient)}
  end
end
