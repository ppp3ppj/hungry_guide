defmodule HungryGuide.Repo.Migrations.CreateReceiptIngredients do
  use Ecto.Migration

  def change do
    create table(:receipt_ingredients, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :quantity, :decimal
      add :receipt_id, references(:receipts, on_delete: :nothing, type: :binary_id)
      add :ingredient_id, references(:ingredients, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:receipt_ingredients, [:receipt_id])
    create index(:receipt_ingredients, [:ingredient_id])
  end
end
