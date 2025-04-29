defmodule HungryGuide.Inventories.Ingredient do
  alias HungryGuide.Inventories
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "ingredients" do
    field :name, :string
    field :quantity, :decimal
    #field :unit_id, :binary_id
    belongs_to :unit, Inventories.Unit

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ingredient, attrs) do
    ingredient
    |> cast(attrs, [:name, :quantity, :unit_id])
    |> validate_required([:name, :quantity, :unit_id])
  end
end
