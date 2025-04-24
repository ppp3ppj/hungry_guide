defmodule HungryGuide.InventoriesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `HungryGuide.Inventories` context.
  """

  @doc """
  Generate a unit.
  """
  def unit_fixture(attrs \\ %{}) do
    {:ok, unit} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> HungryGuide.Inventories.create_unit()

    unit
  end
end
