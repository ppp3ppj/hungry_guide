defmodule HungryGuide.Repo.Migrations.CreateRecipeIngredients do
  use Ecto.Migration

  def change do
    create table(:recipe_ingredients, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :quantity, :decimal
      add :recipe_id, references(:recipes, on_delete: :nothing, type: :binary_id)
      add :ingredient_id, references(:ingredients, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:recipe_ingredients, [:recipe_id])
    create index(:recipe_ingredients, [:ingredient_id])
  end
end
