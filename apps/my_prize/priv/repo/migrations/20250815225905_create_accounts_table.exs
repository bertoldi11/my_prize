defmodule MyPrize.Repo.Migrations.CreateAccountsTable do
  use Ecto.Migration

  def change do
    create table(:accounts, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :email, :string, null: false

      timestamps()
    end

    create unique_index(:accounts, [:email])
  end
end
