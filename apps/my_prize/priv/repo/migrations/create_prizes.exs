defmodule MyPrize.Repo.Migrations.CreatePrizes do
  use Ecto.Migration

  def change do
    create table(:prizes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :description, :string, null: false
      add :account_owner_id, :binary_id, null: false
      add :expiration_date, :date
      add :raffle_winner_id, :binary_id
      add :accounts_applied, {:array, :binary_id}, default: []

      timestamps()
    end

    create unique_index(:prizes, [:name, :account_owner_id], name: :unique_prize_per_account)
  end
end
