defmodule HungryGuide.RecipesTest do
  use HungryGuide.DataCase

  alias HungryGuide.Recipes

  describe "receipts" do
    alias HungryGuide.Recipes.Receipt

    import HungryGuide.RecipesFixtures

    @invalid_attrs %{name: nil, description: nil}

    test "list_receipts/0 returns all receipts" do
      receipt = receipt_fixture()
      assert Recipes.list_receipts() == [receipt]
    end

    test "get_receipt!/1 returns the receipt with given id" do
      receipt = receipt_fixture()
      assert Recipes.get_receipt!(receipt.id) == receipt
    end

    test "create_receipt/1 with valid data creates a receipt" do
      valid_attrs = %{name: "some name", description: "some description"}

      assert {:ok, %Receipt{} = receipt} = Recipes.create_receipt(valid_attrs)
      assert receipt.name == "some name"
      assert receipt.description == "some description"
    end

    test "create_receipt/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recipes.create_receipt(@invalid_attrs)
    end

    test "update_receipt/2 with valid data updates the receipt" do
      receipt = receipt_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description"}

      assert {:ok, %Receipt{} = receipt} = Recipes.update_receipt(receipt, update_attrs)
      assert receipt.name == "some updated name"
      assert receipt.description == "some updated description"
    end

    test "update_receipt/2 with invalid data returns error changeset" do
      receipt = receipt_fixture()
      assert {:error, %Ecto.Changeset{}} = Recipes.update_receipt(receipt, @invalid_attrs)
      assert receipt == Recipes.get_receipt!(receipt.id)
    end

    test "delete_receipt/1 deletes the receipt" do
      receipt = receipt_fixture()
      assert {:ok, %Receipt{}} = Recipes.delete_receipt(receipt)
      assert_raise Ecto.NoResultsError, fn -> Recipes.get_receipt!(receipt.id) end
    end

    test "change_receipt/1 returns a receipt changeset" do
      receipt = receipt_fixture()
      assert %Ecto.Changeset{} = Recipes.change_receipt(receipt)
    end
  end
end
