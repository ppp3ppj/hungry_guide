defmodule HungryGuide.InventoriesTest do
  use HungryGuide.DataCase

  alias HungryGuide.Inventories

  ~S"""
  describe "units" do
    alias HungryGuide.Inventories.Unit

    import HungryGuide.InventoriesFixtures

    @invalid_attrs %{name: nil}

    test "list_units/0 returns all units" do
      unit = unit_fixture()
      assert Inventories.list_units() == [unit]
    end

    test "get_unit!/1 returns the unit with given id" do
      unit = unit_fixture()
      assert Inventories.get_unit!(unit.id) == unit
    end

    test "create_unit/1 with valid data creates a unit" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Unit{} = unit} = Inventories.create_unit(valid_attrs)
      assert unit.name == "some name"
    end

    test "create_unit/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Inventories.create_unit(@invalid_attrs)
    end

    test "update_unit/2 with valid data updates the unit" do
      unit = unit_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Unit{} = unit} = Inventories.update_unit(unit, update_attrs)
      assert unit.name == "some updated name"
    end

    test "update_unit/2 with invalid data returns error changeset" do
      unit = unit_fixture()
      assert {:error, %Ecto.Changeset{}} = Inventories.update_unit(unit, @invalid_attrs)
      assert unit == Inventories.get_unit!(unit.id)
    end

    test "delete_unit/1 deletes the unit" do
      unit = unit_fixture()
      assert {:ok, %Unit{}} = Inventories.delete_unit(unit)
      assert_raise Ecto.NoResultsError, fn -> Inventories.get_unit!(unit.id) end
    end

    test "change_unit/1 returns a unit changeset" do
      unit = unit_fixture()
      assert %Ecto.Changeset{} = Inventories.change_unit(unit)
    end
  end

  describe "ingredients" do
    alias HungryGuide.Inventories.Ingredient

    import HungryGuide.InventoriesFixtures

    @invalid_attrs %{name: nil, quantity: nil}

    test "list_ingredients/0 returns all ingredients" do
      ingredient = params_with_assocs(:ingredient)
      assert Inventories.list_ingredients() == [ingredient]
    end

    test "get_ingredient!/1 returns the ingredient with given id" do
      ingredient = params_with_assocs(:ingredient)
      assert Inventories.get_ingredient!(ingredient.id) == ingredient
    end

    test "create_ingredient/1 with valid data creates a ingredient" do
      valid_attrs = %{name: "some name", quantity: "120.5"}

      assert {:ok, %Ingredient{} = ingredient} = Inventories.create_ingredient(valid_attrs)
      assert ingredient.name == "some name"
      assert ingredient.quantity == Decimal.new("120.5")
    end

    test "create_ingredient/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Inventories.create_ingredient(@invalid_attrs)
    end

    test "update_ingredient/2 with valid data updates the ingredient" do
      ingredient = params_with_assocs(:ingredient)
      update_attrs = %{name: "some updated name", quantity: "456.7"}

      assert {:ok, %Ingredient{} = ingredient} =
               Inventories.update_ingredient(ingredient, update_attrs)

      assert ingredient.name == "some updated name"
      assert ingredient.quantity == Decimal.new("456.7")
    end

    test "update_ingredient/2 with invalid data returns error changeset" do
      # ingredient = ingredient_fixture()

      ingredient = params_with_assocs(:ingredient)

      assert {:error, %Ecto.Changeset{}} =
               Inventories.update_ingredient(ingredient, %{unit_id: nil})

      assert ingredient == Inventories.get_ingredient!(ingredient.id)
    end

    test "delete_ingredient/1 deletes the ingredient" do
      ingredient = params_with_assocs(:ingredient)
      assert {:ok, %Ingredient{}} = Inventories.delete_ingredient(ingredient)
      assert_raise Ecto.NoResultsError, fn -> Inventories.get_ingredient!(ingredient.id) end
    end

    test "change_ingredient/1 returns a ingredient changeset" do
      ingredient = params_with_assocs(:ingredient)
      assert %Ecto.Changeset{} = Inventories.change_ingredient(ingredient)
    end
  end
"""
end
