defmodule HungryGuide.Recipes do
  @moduledoc """
  The Recipes context.
  """

  import Ecto.Query, warn: false
  alias HungryGuide.Recipes.ReceiptIngredient
  alias HungryGuide.Repo

  alias HungryGuide.Recipes.Receipt

  @doc """
  Returns the list of receipts.

  ## Examples

      iex> list_receipts()
      [%Receipt{}, ...]

  """
  def list_receipts do
    Repo.all(Receipt)
  end

  def list_receipts, do: list_receipts([])

  def list_receipts(criteria) when is_list(criteria) do
    Repo.all(receipt_query(criteria))
  end

  defp receipt_query(criteria) do
    query = from(b in Receipt)

    Enum.reduce(criteria, query, fn
      {:user, user}, query ->
        from b in query, where: b.creator_id == ^user.id

      {:preload, bindings}, query ->
        preload(query, ^bindings)

      _, query ->
        query
    end)
  end

  @doc """
  Gets a single receipt.

  Raises `Ecto.NoResultsError` if the Receipt does not exist.

  ## Examples

      iex> get_receipt!(123)
      %Receipt{}

      iex> get_receipt!(456)
      ** (Ecto.NoResultsError)

  """
  def get_receipt!(id), do: Repo.get!(Receipt, id)

  @doc """
  Creates a receipt.

  ## Examples

      iex> create_receipt(%{field: value})
      {:ok, %Receipt{}}

      iex> create_receipt(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_receipt(attrs \\ %{}) do
    %Receipt{}
    |> Receipt.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a receipt.

  ## Examples

      iex> update_receipt(receipt, %{field: new_value})
      {:ok, %Receipt{}}

      iex> update_receipt(receipt, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_receipt(%Receipt{} = receipt, attrs) do
    receipt
    |> Receipt.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a receipt.

  ## Examples

      iex> delete_receipt(receipt)
      {:ok, %Receipt{}}

      iex> delete_receipt(receipt)
      {:error, %Ecto.Changeset{}}

  """
  def delete_receipt(%Receipt{} = receipt) do
    Repo.delete(receipt)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking receipt changes.

  ## Examples

      iex> change_receipt(receipt)
      %Ecto.Changeset{data: %Receipt{}}

  """
  def change_receipt(%Receipt{} = receipt, attrs \\ %{}) do
    Receipt.changeset(receipt, attrs)
  end

  def create_receipt_with_ingredients(attrs) do
    # Extract name and description attributes
    receipt_attrs = Map.take(attrs, ["name", "description", "creator_id"])
    ingredients_map = Map.drop(attrs, ["name", "description", "creator_id"])
    # Convert ingredient data into ReceiptIngredient structs

    IO.inspect(receipt_attrs, label: "TTTT")

    receipt_ingredients =
      build_receipt_ingredients(Map.get(ingredients_map, "receipt_ingredients", %{}))

    %Receipt{}
    |> Receipt.changeset(receipt_attrs)
    |> Ecto.Changeset.put_assoc(:receipt_ingredients, receipt_ingredients)
    |> Repo.insert()
  end

  defp build_receipt_ingredients(ingredients_map) do
    # Convert each ingredient ID and quantity into a ReceiptIngredient struct
    ingredients_map
    |> Enum.filter(fn {_id, qty} ->
      decimal_qty = if is_integer(qty), do: Decimal.new(qty), else: qty
      Decimal.compare(decimal_qty, Decimal.new(0)) == :gt
    end)
    |> Enum.map(fn {ingredient_id, quantity} ->
      %ReceiptIngredient{
        ingredient_id: ingredient_id,
        # assuming quantity is a string, convert to Decimal
        # quantity: to_decimal(quantity)
        quantity: Decimal.new(quantity)
      }
    end)
  end

  def get_receipt_ingredients(receipt_id) do
    Repo.all(
      from ri in ReceiptIngredient,
        where: ri.receipt_id == ^receipt_id,
        # Optionally preload the ingredient data
        preload: [:ingredient]
    )
  end

  def update_receipt_with_ingredients(attrs, receipt) do
    receipt = Repo.get!(Receipt, receipt.id) |> Repo.preload(:receipt_ingredients)
    # Extract name and description attributes
    receipt_attrs = Map.take(attrs, ["name", "description", "id", "creator_id"])
    ingredients_map = Map.drop(attrs, ["name", "description", "creator_id"])

    # Convert ingredient data into ReceiptIngredient structs
    receipt_ingredients =
      build_receipt_ingredients(Map.get(ingredients_map, "receipt_ingredients", %{}))

    receipt
    |> Receipt.changeset(receipt_attrs)
    |> Ecto.Changeset.put_assoc(:receipt_ingredients, receipt_ingredients)
    |> Repo.update()
  end
end
