defmodule MyPrize.Repo do
  use Ecto.Repo,
    otp_app: :my_prize,
    adapter: Ecto.Adapters.Postgres
end
