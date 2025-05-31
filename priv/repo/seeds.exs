# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     HungryGuide.Repo.insert!(%HungryGuide.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias HungryGuide.Catalog.Category
alias HungryGuide.Accounts
alias HungryGuide.Repo

admin_email = "admin@admin.com"
password = "supersecret123"
admin_name = "admin"

user_email = "user@user.com"
user_name = "user"

case Accounts.get_user_by_email(admin_email) do
  nil ->
    {:ok, _admin} = Accounts.register_user(%{
      name: admin_name,
      email: admin_email,
      password: password
    })

    IO.puts("Default admin user created: #{admin_email}")

  _user ->
    IO.puts("Admin user already exists: #{admin_email}")
end

case Accounts.get_user_by_email(user_email) do
  nil ->
    {:ok, _user} = Accounts.register_user(%{
      name: user_name,
      email: user_email,
      password: password
    })

    IO.puts("Default user created: #{user_email}")

  _user ->
    IO.puts("User already exists: #{user_email}")
end


# Ingredient categories
ingredient_categories = [
  %{name: "Vegetables", type: :ingredient},
  %{name: "Meats", type: :ingredient},
  %{name: "Spices", type: :ingredient}
]

# Recipe categories
recipe_categories = [
  %{name: "Main Course", type: :recipe},
  %{name: "Appetizers", type: :recipe},
  %{name: "Desserts", type: :recipe}
]

# Insert all categories
Enum.each(ingredient_categories ++ recipe_categories, fn attrs ->
  %Category{}
  |> Category.changeset(attrs)
  |> Repo.insert!()
end)

