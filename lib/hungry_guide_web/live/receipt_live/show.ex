defmodule HungryGuideWeb.ReceiptLive.Show do
  use HungryGuideWeb, :live_view

  alias HungryGuide.Inventories
  alias HungryGuide.Recipes

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    receipt = Recipes.get_recipe(id, preload: [:category])
    receipt_ingredients = Recipes.get_recipe_ingredients(id)
    ingredients = Inventories.list_ingredients()
    IO.inspect(receipt_ingredients)

    categories =
      HungryGuide.Catalog.list_categories_by_type(:recipe)
      |> Enum.map(&{&1.name, &1.id})

    initial_quantities = Map.new(ingredients, fn ingr -> {ingr.id, 0} end)

    # Merge actual quantities from receipt_ingredients
    quantities =
      Enum.reduce(receipt_ingredients, initial_quantities, fn ri, acc ->
        Map.put(acc, ri.ingredient_id, ri.quantity)
      end)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:receipt, receipt)
     |> assign(:ingredients, ingredients)
     |> assign(:quantities, quantities)
     |> assign(:categories, categories)
     |> assign(:receipt_ingredients, receipt_ingredients)}
  end

  defp page_title(:show), do: "Show Receipt"
  defp page_title(:edit), do: "Edit Receipt"

  @impl true
  def handle_event("increment", %{"id" => ingr_id}, socket) do
    updated_quantities =
      Map.update!(socket.assigns.quantities, ingr_id, fn val ->
        Decimal.add(val, 1)
      end)

    {:noreply, assign(socket, quantities: updated_quantities)}
  end

  @impl true
  def handle_event("reset_ingredient", %{"id" => id}, socket) do
    new_quantities = Map.put(socket.assigns.quantities, id, Decimal.new(0))
    {:noreply, assign(socket, quantities: new_quantities)}
  end

  @impl true
  def handle_event("update_quantity", %{"id" => id, "quantity" => quantity}, socket) do
    {:noreply,
     update(socket, :quantities, fn q ->
       Map.put(q, id, Decimal.new(quantity))
     end)}
  end
end
