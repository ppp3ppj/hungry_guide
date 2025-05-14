defmodule HungryGuide.Repo.Migrations.AddCreatorIdToReceipts do
  use Ecto.Migration

  def change do
    alter table(:receipts) do
      add :creator_id, references(:users, type: :binary_id, on_delete: :nothing)
    end

    create index(:receipts, [:creator_id])
  end
end
