defmodule HungryGuide.InventoriesTest do
  use HungryGuide.DataCase

  alias HungryGuide.Inventories

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
end
