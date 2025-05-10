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

alias HungryGuide.Accounts
admin_email = "admin@admin.com"
admin_password = "supersecret123"
admin_name = "admin"

case Accounts.get_user_by_email(admin_email) do
  nil ->
    {:ok, _admin} = Accounts.register_user(%{
      name: admin_name,
      email: admin_email,
      password: admin_password
    })

    IO.puts("Default admin user created: #{admin_email}")

  _user ->
    IO.puts("Admin user already exists: #{admin_email}")
end
