defmodule MyPrize.Prizes.Schemas.Prizes do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "prizes" do
    field :name, :string
    field :description, :string
    field :account_owner_id, :binary_id
    field :expiration_date, :utc_date
    field :raffle_winner_id, :binary_id, null: true
    field :accounts_applied, {:array, :binary_id}, default: []

    timestamps()
  end

  @doc false
  def changeset(prize, attrs) do
    prize
    |> cast(attrs, [:name, :description, :raffle_at, :raffle_winner_id, :accounts_applied, :account_owner_id])
    |> validate_required([:name, :description, :raffle_at])
    |> unique_constraint(:name, :account_owner_id, name: :unique_prize_per_account)
  end
end
