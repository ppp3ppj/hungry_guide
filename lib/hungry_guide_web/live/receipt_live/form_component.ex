defmodule HungryGuideWeb.ReceiptLive.FormComponent do
  use HungryGuideWeb, :live_component

  alias HungryGuide.Recipes

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage receipt records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="receipt-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="text" label="Description" />

        <div class="grid grid-cols-3 gap-4">
          <%= for ingr <- @ingredients do %>
            <button
              type="button"
              class="btn"
              id={"btn-#{ingr.id}"}
              phx-value-id={ingr.id}
              phx-hook="ClickOrHold"
            >
              {ingr.name}
              <div class="badge badge-sm badge-secondary">{@quantities[ingr.id]}</div>
            </button>
          <% end %>
        </div>

        <:actions>
          <.button phx-disable-with="Saving...">Save Receipt</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{receipt: receipt} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Recipes.change_recipe(receipt))
     end)}
  end

  @impl true
  def handle_event("validate", %{"recipe" => receipt_params}, socket) do
    changeset = Recipes.change_recipe(socket.assigns.receipt, receipt_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"recipe" => receipt_params}, socket) do
    save_receipt(socket, socket.assigns.action, receipt_params)
  end

  defp save_receipt(socket, :edit, receipt_params) do
    ingredient_quantities = socket.assigns.quantities
    receipt = socket.assigns.receipt
    params = Map.merge(receipt_params, %{"receipt_ingredients" => ingredient_quantities})

    case Recipes.update_recipe_with_ingredients(params, receipt) do
      {:ok, receipt} ->
        notify_parent({:saved, receipt})

        {:noreply,
         socket
         |> put_flash(:info, "Receipt updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_receipt(socket, :new, receipt_params) do
    ingredient_quantities = socket.assigns.quantities
    receipt_params = Map.put(receipt_params, "creator_id", socket.assigns.current_user.id)
    params = Map.merge(receipt_params, %{"receipt_ingredients" => ingredient_quantities})

    case Recipes.create_recipe_with_ingredients(params) do
      {:ok, receipt} ->
        notify_parent({:saved, receipt})

        {:noreply,
         socket
         |> put_flash(:info, "Receipt created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
