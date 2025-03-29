defmodule HungryGuide.Repo do
  use Ecto.Repo,
    otp_app: :hungry_guide,
    adapter: Ecto.Adapters.Postgres
end
