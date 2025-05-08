defmodule HungryGuide.Recipes.ReceiptIngredient do
  alias HungryGuide.Inventories
  alias HungryGuide.Recipes
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "receipt_ingredients" do
    field :quantity, :decimal

    belongs_to :receipt, Recipes.Receipt
    belongs_to :ingredient, Inventories.Ingredient

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(receipt_ingredient, attrs) do
    receipt_ingredient
    |> cast(attrs, [:quantity, :ingredient_id])
    |> validate_required([:quantity, :ingredient_id])
  end
end
