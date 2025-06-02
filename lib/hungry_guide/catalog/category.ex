defmodule HungryGuide.Catalog.Category do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "categories" do
    field :name, :string
    #field :type, :string
    field :type, Ecto.Enum,
      values: [:ingredient, :recipe]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :type])
    |> validate_required([:name, :type])
  end
end
