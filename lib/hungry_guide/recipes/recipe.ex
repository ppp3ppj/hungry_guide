defmodule HungryGuide.Recipes.Recipe do
  alias HungryGuide.Recipes
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "recipes" do
    field :name, :string
    field :description, :string

    has_many :recipe_ingredients, Recipes.RecipeIngredient,
      on_replace: :delete,
      on_delete: :delete_all

    has_many :ingredients, through: [:recipe_ingredients, :ingredient]

    belongs_to :creator, HungryGuide.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [:name, :description, :creator_id])
    |> validate_required([:name, :description, :creator_id])
    |> cast_assoc(:recipe_ingredients)
  end
end
