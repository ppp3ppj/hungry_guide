defmodule HungryGuideWeb.ReceiptLive.Show do
  use HungryGuideWeb, :live_view

  alias HungryGuide.Recipes

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    receipt = Recipes.get_receipt!(id)
    receipt_ingredients = Recipes.get_receipt_ingredients(id)
    IO.inspect(receipt_ingredients)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:receipt, receipt)
     |> assign(:receipt_ingredients, receipt_ingredients)}
  end

  defp page_title(:show), do: "Show Receipt"
  defp page_title(:edit), do: "Edit Receipt"
end
