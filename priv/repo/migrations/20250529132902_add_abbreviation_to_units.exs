defmodule HungryGuide.Repo.Migrations.AddAbbreviationToUnits do
  use Ecto.Migration

  def change do
    alter table(:units) do
      add :abbreviation, :string
    end
  end
end
