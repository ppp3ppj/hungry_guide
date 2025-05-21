defmodule HungryGuide.Repo.Migrations.AddCreatorIdToRecipes do
  use Ecto.Migration

  def change do
    alter table(:recipes) do
      add :creator_id, references(:users, type: :binary_id, on_delete: :nothing)
    end

    create index(:recipes, [:creator_id])
  end
end
