defmodule HungryGuide.Factory do
  use ExMachina.Ecto, repo: HungryGuide.Repo

  alias HungryGuide.Accounts

  alias HungryGuide.Inventories.Unit
  alias HungryGuide.Inventories.Ingredient

  def without_preloads(%Ingredient{} = ingredient), do: Ecto.reset_fields(ingredient, [:unit])

  def user_factory do
    %Accounts.User{
      name: sequence(:user_name, &"Hungry PPP#{&1}"),
      email: sequence(:email, &"email-#{&1}"),
      hashed_password: "_"
    }
  end

  def unit_factory do
    %Unit{
      name: sequence(:unit_name, &"Unit #{&1}")
    }
  end

  def ingredient_factory do
    %Ingredient{
      name: sequence(:unit_name, &"Ingredient #{&1}"),
      quantity: Decimal.new("10"),
      unit: build(:unit)
    }
  end
end
