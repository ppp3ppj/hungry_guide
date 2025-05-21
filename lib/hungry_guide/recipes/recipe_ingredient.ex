defmodule HungryGuide.Recipes.RecipeIngredient do
  alias HungryGuide.Inventories
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "recipe_ingredients" do
    field :quantity, :decimal

    belongs_to :recipe, Recipes.Receipt
    belongs_to :ingredient, Inventories.Ingredient

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(recipe_ingredient, attrs) do
    recipe_ingredient
    |> cast(attrs, [:quantity, :ingredient_id])
    |> validate_required([:quantity, :ingredient_id])
  end
end
