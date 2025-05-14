defmodule HungryGuide.Repo.Migrations.AddUserIdToReceipts do
  use Ecto.Migration

  def change do
    alter table(:receipts) do
      add :user_id, references(:users, type: :binary_id, on_delete: :nothing)
    end

    create index(:receipts, [:user_id])
  end
end
