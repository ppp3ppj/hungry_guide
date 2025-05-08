defmodule HungryGuide.Repo.Migrations.CreateReceipts do
  use Ecto.Migration

  def change do
    create table(:receipts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :string

      timestamps(type: :utc_datetime)
    end
  end
end
