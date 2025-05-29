defmodule HungryGuide.Inventories.Unit do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "units" do
    field :name, :string
    field :abbreviation, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(unit, attrs) do
    unit
    |> cast(attrs, [:name, :abbreviation])
    |> validate_required([:name, :abbreviation])
  end
end
