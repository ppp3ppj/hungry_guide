defmodule HungryGuide.Repo.Migrations.AddCategoryToIngredients do
  use Ecto.Migration

  def change do
    alter table(:ingredients) do
      add :category_id, references(:categories, type: :uuid, on_delete: :nothing), null: false
    end

    create index(:ingredients, [:category_id])
  end
end
