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
        <:actions>
          <.button phx-disable-with="Saving...">Save Receipt</.button>
        </:actions>
      </.simple_form>

      <%= for ingr <- @ingredients do %>
        <label>
          <input
            type="checkbox"
            phx-value-id={ingr.id}
            phx-click="toggle_ingredient"
            checked={ingr.id in @selected_ingredients}
            class="checkbox"
          />
          {ingr.name}
        </label>
      <%= if ingr.id in @selected_ingredients do %>
        <input
          type="number"
          name="quantity"
          phx-debounce="500"
          phx-change="update_quantity"
          phx-value-id={ingr.id}
          value={Map.get(@quantities, ingr.id, "")}
          class="border rounded ml-2 w-20"
          placeholder="Amount"
        />
      <% end %>
      <% end %>
    </div>
    """
  end

  @impl true
  def update(%{receipt: receipt} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Recipes.change_receipt(receipt))
     end)}
  end

  @impl true
  def handle_event("validate", %{"receipt" => receipt_params}, socket) do
    changeset = Recipes.change_receipt(socket.assigns.receipt, receipt_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"receipt" => receipt_params}, socket) do
    save_receipt(socket, socket.assigns.action, receipt_params)
  end

  defp save_receipt(socket, :edit, receipt_params) do
    case Recipes.update_receipt(socket.assigns.receipt, receipt_params) do
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
    case Recipes.create_receipt(receipt_params) do
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
