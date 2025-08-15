defmodule MyPrize.Bussiness do
  @moduledoc """
  The Bussiness context for MyPrize, handling business logic and interactions
  between different contexts such as Prizes and Accounts.
  """
  alias MyPrize.Prizes
  alias MyPrize.Accounts

  def new_account(attrs) do
    case Accounts.get_account_by_email(attrs["email"]) do
      nil ->
        Accounts.create_account(attrs)

      _account ->
        {:error, "Account with this email already exists"}
    end
  end

  def new_prize(attrs) do
    Prizes.create_prize(attrs)
  end

  def apply_for_prize(account_id, prize_id) do
    case Prizes.get_prize(prize_id) do
      nil ->
        {:error, "Prize not found"}

      prize ->
        case Date.compare(Date.utc_today(), prize.expiration_date) do
          :gt ->
            {:error, "Prize has expired"}

          _ ->
            apply_account_to_prize(account_id, prize)
        end
    end
  end

  def prize_result(prize_id) do
    case Prizes.get_prize(prize_id) do
      nil ->
        {:error, "Prize not found"}

      prize ->
        if prize.raffle_winner_id do
          case Accounts.get_account(prize.raffle_winner_id) do
            nil -> {:error, "Winner account not found"}
            winner -> {:ok, %{prize: prize, winner: winner}}
          end
        else
          {:error, "Prize has not been raffled yet"}
        end
    end
  end

  def raffle_prize(prize_id) do
    case Prizes.get_prize(prize_id) do
      nil ->
        {:error, "Prize not found"}

      prize ->
        if prize.raffle_winner_id do
          {:error, "Prize already has a winner"}
        else
          winner = select_winner(prize.accounts_applied)
          Prizes.update_prize(prize.id, %{raffle_winner_id: winner})
        end
    end
  end

  defp select_winner(accounts) do
    if Enum.empty?(accounts) do
      nil
    else
      Enum.random(accounts)
    end
  end

  defp apply_account_to_prize(account_id, prize) do
    case Accounts.get_account(account_id) do
      nil ->
        {:error, "Account not found"}

      account ->
        if account.id in prize.accounts_applied do
          {:error, "Account already applied for this prize"}
        else
          updated_accounts = [account.id | prize.accounts_applied]
          Prizes.update_prize(prize.id, %{accounts_applied: updated_accounts})
          {:ok, prize}
        end
    end
  end
end
