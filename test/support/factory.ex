defmodule HungryGuide.Factory do
  use ExMachina.Ecto, repo: HungryGuide.Repo

  alias HungryGuide.Accounts

  def user_factory do
    %Accounts.User{
      name: sequence(:user_name, &"Hungry PPP#{&1}"),
      email: sequence(:email, &"email-#{&1}"),
      hashed_password: "_"
    }
  end
end
