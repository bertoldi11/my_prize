defmodule MyPrize.Accounts do
  @moduledoc """
  The Accounts context for MyPrize, managing user accounts and authentication.
  """

  alias MyPrize.Accounts.Schemas.Account
  alias MyPrize.Repo

  @doc """
  Creates a new account with the given attributes.
  """
  def create_account(attrs) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Finds an account by its ID.
  """
  def get_account(id) do
    Repo.get(Account, id)
  end

  @doc """
  Finds an account by its email.
  """
  def get_account_by_email(email) do
    Repo.get_by(Account, email: email)
  end
end
