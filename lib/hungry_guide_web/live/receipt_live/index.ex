defmodule HungryGuideWeb.ReceiptLive.Index do
  use HungryGuideWeb, :live_view

  alias HungryGuide.Inventories
  alias HungryGuide.Recipes
  alias HungryGuide.Recipes.Receipt

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> stream(:receipts, Recipes.list_receipts())

    # {:ok, stream(socket, :receipts, Recipes.list_receipts())}
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    # Fetch receipt_ingredients and the receipt
    receipt_ingredients = HungryGuide.Recipes.get_receipt_ingredients(id)
    ingredients = Inventories.list_ingredients()
    receipt = Recipes.get_receipt!(id)

    # Create a map of ingredient IDs to quantities (for easy lookup)
    quantities =
      Enum.reduce(receipt_ingredients, %{}, fn ri, acc ->
        Map.put(acc, ri.ingredient_id, ri.quantity)
      end)

    # Assign receipt_ingredients and quantities to the socket
    socket
    |> assign(:page_title, "Edit Receipt")
    |> assign(:ingredients, ingredients)
    |> assign(:receipt, receipt)
    |> assign(:receipt_ingredients, receipt_ingredients)
    |> assign(:quantities, quantities)
  end

  defp apply_action(socket, :new, _params) do
    ingredients = Inventories.list_ingredients()
    intial_quantities = Map.new(ingredients, fn ingr -> {ingr.id, 0} end)

    socket
    |> assign(:page_title, "New Receipt")
    |> assign(:receipt, %Receipt{})
    |> assign(:ingredients, ingredients)
    |> assign(:quantities, intial_quantities)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Receipts")
    |> assign(:receipt, nil)
  end

  @impl true
  def handle_info({HungryGuideWeb.ReceiptLive.FormComponent, {:saved, receipt}}, socket) do
    {:noreply, stream_insert(socket, :receipts, receipt)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    receipt = Recipes.get_receipt!(id)
    {:ok, _} = Recipes.delete_receipt(receipt)

    {:noreply, stream_delete(socket, :receipts, receipt)}
  end

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
