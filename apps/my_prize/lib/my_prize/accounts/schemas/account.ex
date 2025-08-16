defmodule MyPrize.Accounts.Schemas.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  @derived_by {Jason.Encoder, only: [:id, :name, :email, :inserted_at, :updated_at]}

  schema "accounts" do
    field :name, :string
    field :email, :string

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
    |> unique_constraint(:email)
  end
end
