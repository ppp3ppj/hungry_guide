defmodule HungryGuide.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `HungryGuide.Catalog` context.
  """

  @doc """
  Generate a category.
  """
  def category_fixture(attrs \\ %{}) do
    {:ok, category} =
      attrs
      |> Enum.into(%{
        name: "some name",
        type: "some type"
      })
      |> HungryGuide.Catalog.create_category()

    category
  end
end
