defmodule HungryGuide.Repo.Migrations.CreateIngredients do
  use Ecto.Migration

  def change do
    create table(:ingredients, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :quantity, :decimal
      add :unit_id, references(:units, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:ingredients, [:unit_id])
  end
end
