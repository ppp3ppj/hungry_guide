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
    receipt = Recipes.get_receipt!(id)
    receipt_ingredients = Recipes.get_receipt_ingredients(id)
    ingredients = Inventories.list_ingredients()
    IO.inspect(receipt_ingredients)

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
     |> assign(:receipt_ingredients, receipt_ingredients)}
  end

  defp page_title(:show), do: "Show Receipt"
  defp page_title(:edit), do: "Edit Receipt"
end
