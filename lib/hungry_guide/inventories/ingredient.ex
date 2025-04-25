defmodule HungryGuide.Inventories.Ingredient do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "ingredients" do
    field :name, :string
    field :quantity, :decimal
    field :unit_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ingredient, attrs) do
    ingredient
    |> cast(attrs, [:name, :quantity])
    |> validate_required([:name, :quantity])
  end
end
