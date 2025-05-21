defmodule HungryGuide.Inventories.Ingredient do
  alias HungryGuide.Recipes
  alias HungryGuide.Inventories
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "ingredients" do
    field :name, :string
    #field :unit_id, :binary_id
    belongs_to :unit, Inventories.Unit

    has_many :recipe_ingredients, Recipes.RecipeIngredient
    has_many :ingredient, through: [:recipe_ingredients, :recipe]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ingredient, attrs) do
    ingredient
    |> cast(attrs, [:name, :unit_id])
    |> validate_required([:name, :unit_id])
  end
end
