defmodule HungryGuide.RecipesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `HungryGuide.Recipes` context.
  """

  @doc """
  Generate a receipt.
  """
  def receipt_fixture(attrs \\ %{}) do
    {:ok, receipt} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> HungryGuide.Recipes.create_receipt()

    receipt
  end
end
