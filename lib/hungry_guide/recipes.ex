defmodule HungryGuide.Recipes do
  @moduledoc """
  The Recipes context.
  """

  import Ecto.Query, warn: false
  alias HungryGuide.Recipes.RecipeIngredient
  alias HungryGuide.Repo

  alias HungryGuide.Recipes.Recipe

  @doc """
  Returns the list of receipts.

  ## Examples

      iex> list_recipes()
      [%Recipe{}, ...]

  """

  # def list_recipes do
  #  Repo.all(Recipe)
  # end

  def list_recipes, do: list_recipes([])

  def list_recipes(criteria) when is_list(criteria) do
    Repo.all(recipe_query(criteria))
  end

  defp recipe_query(criteria) do
    query = from(b in Recipe)

    Enum.reduce(criteria, query, fn
      {:user, user}, query ->
        from b in query, where: b.creator_id == ^user.id

      {:category, category_id}, query ->
        from b in query, where: b.category_id == ^category_id

      {:preload, bindings}, query ->
        preload(query, ^bindings)

      _, query ->
        query
    end)
  end

  @doc """
  Gets a single recipe.

  Raises `Ecto.NoResultsError` if the Recipe does not exist.

  ## Examples

      iex> get_recipe!(123)
      %Recipe{}

      iex> get_recipe!(456)
      ** (Ecto.NoResultsError)

  """
  def get_recipe!(id), do: Repo.get!(Recipe, id)

  def get_recipe(id, criteria \\ %{}) do
    Repo.get(recipe_query(criteria), id)
  end

  @doc """
  Creates a recipe.

  ## Examples

      iex> create_recipe(%{field: value})
      {:ok, %Recipe{}}

      iex> create_recipe(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_recipe(attrs \\ %{}) do
    %Recipe{}
    |> Recipe.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a recipe.

  ## Examples

      iex> update_recipe(recipe, %{field: new_value})
      {:ok, %Recipe{}}

      iex> update_recipe(recipe, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_recipe(%Recipe{} = recipe, attrs) do
    recipe
    |> Recipe.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a recipe.

  ## Examples

      iex> delete_recipe(recipe)
      {:ok, %Recipe{}}

      iex> delete_recipe(recipe)
      {:error, %Ecto.Changeset{}}

  """
  def delete_recipe(%Recipe{} = recipe) do
    Repo.delete(recipe)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking recipe changes.

  ## Examples

      iex> change_recipe(recipe)
      %Ecto.Changeset{data: %Recipe{}}

  """
  def change_recipe(%Recipe{} = recipe, attrs \\ %{}) do
    Recipe.changeset(recipe, attrs)
  end

  def create_recipe_with_ingredients(attrs) do
    # Extract name and description attributes
    receipt_attrs =
      Map.take(attrs, ["name", "description", "creator_id", "category_id"])
      |> IO.inspect(label: "Now ppp:")

    ingredients_map = Map.drop(attrs, ["name", "description", "creator_id"])
    # Convert ingredient data into ReceiptIngredient structs

    receipt_ingredients =
      build_recipe_ingredients(Map.get(ingredients_map, "receipt_ingredients", %{}))

    %Recipe{}
    |> Recipe.changeset(receipt_attrs)
    |> Ecto.Changeset.put_assoc(:recipe_ingredients, receipt_ingredients)
    |> Repo.insert()
  end

  defp build_recipe_ingredients(ingredients_map) do
    # Convert each ingredient ID and quantity into a ReceiptIngredient struct
    ingredients_map
    |> Enum.filter(fn {_id, qty} ->
      decimal_qty = if is_integer(qty), do: Decimal.new(qty), else: qty
      Decimal.compare(decimal_qty, Decimal.new(0)) == :gt
    end)
    |> Enum.map(fn {ingredient_id, quantity} ->
      %RecipeIngredient{
        ingredient_id: ingredient_id,
        # assuming quantity is a string, convert to Decimal
        # quantity: to_decimal(quantity)
        quantity: Decimal.new(quantity)
      }
    end)
  end

  def get_recipe_ingredients(recipe_id) do
    Repo.all(
      from ri in RecipeIngredient,
        where: ri.recipe_id == ^recipe_id,
        # Optionally preload the ingredient data
        preload: [:ingredient]
    )
  end

  def update_recipe_with_ingredients(attrs, recipe) do
    recipe = Repo.get!(Recipe, recipe.id) |> Repo.preload(:recipe_ingredients)
    # Extract name and description attributes
    receipt_attrs = Map.take(attrs, ["name", "description", "id", "creator_id", "category_id"])
    ingredients_map = Map.drop(attrs, ["name", "description", "creator_id"])

    # Convert ingredient data into ReceiptIngredient structs
    receipt_ingredients =
      build_recipe_ingredients(Map.get(ingredients_map, "receipt_ingredients", %{}))

    recipe
    |> Recipe.changeset(receipt_attrs)
    |> Ecto.Changeset.put_assoc(:recipe_ingredients, receipt_ingredients)
    |> Repo.update()
  end
end
