defmodule HungryGuide.Recipes.ReceiptIngredient do
  alias HungryGuide.Inventories
  alias HungryGuide.Recipes
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "receipt_ingredients" do
    field :quantity, :decimal
    #field :receipt_id, :binary_id
    #field :ingredient_id, :binary_id

    belongs_to :receipt, Recipes.Receipt
    belongs_to :ingredient, Inventories.Ingredient

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(receipt_ingredient, attrs) do
    receipt_ingredient
    |> cast(attrs, [:quantity])
    |> validate_required([:quantity])
  end
end
