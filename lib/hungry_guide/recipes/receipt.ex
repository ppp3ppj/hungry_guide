defmodule HungryGuide.Recipes.Receipt do
  alias HungryGuide.Recipes
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "receipts" do
    field :name, :string
    field :description, :string

    has_many :receipt_ingredients, Recipes.ReceiptIngredient
    has_many :ingredients, through: [:receipt_ingredients, :ingredient]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(receipt, attrs) do
    receipt
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
