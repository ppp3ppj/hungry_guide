defmodule HungryGuide.Repo.Migrations.AddCategoryIdToRecipes do
  use Ecto.Migration

  def change do
    alter table(:recipes) do
      add :category_id, references(:categories, type: :binary_id, on_delete: :nilify_all)
    end

    create index(:recipes, [:category_id])
  end
end
