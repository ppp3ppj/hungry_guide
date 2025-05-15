defmodule HungryGuide.Repo.Migrations.RemoveQuantityFromIngredients do
  use Ecto.Migration

  def change do
    alter table(:ingredients) do
      remove :quantity
    end
  end
end
