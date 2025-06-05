defmodule HungryGuideWeb.RecipeShowLive do
  use HungryGuideWeb, :live_view

  alias HungryGuide.Inventories
  alias HungryGuide.Recipes
  alias HungryGuide.Recipes.Recipe

  @impl true
  def mount(_params, _session, socket) do
    IO.puts("PPP me")
    ingredients = Inventories.list_ingredients()
    initial_quantities = Map.new(ingredients, fn ingr -> {ingr.id, 0} end)

    categories =
      HungryGuide.Catalog.list_categories_by_type(:recipe)
      |> Enum.map(&{&1.name, &1.id})

    {:ok,
     socket
     |> assign(:page_title, "New Receipt")
     |> assign(:receipt, %Recipe{})
     |> assign(:categories, categories)
     |> assign(:ingredients, ingredients)
     |> assign(:quantities, initial_quantities)}
  end

  @impl true
  def handle_params(%{"id" => id}, _uri, socket) do
    receipt = Recipes.get_recipe!(id)
    receipt_ingredients = Recipes.get_recipe_ingredients(id)

    updated_quantities =
      Enum.reduce(receipt_ingredients, socket.assigns.quantities, fn ri, acc ->
        Map.put(acc, ri.ingredient_id, ri.quantity)
      end)

    {:noreply,
     socket
     |> assign(:receipt, receipt)
     |> assign(:quantities, updated_quantities)
     |> assign(:page_title, "Edit Receipt")
     |> assign(:action, :edit)}
  end
end
