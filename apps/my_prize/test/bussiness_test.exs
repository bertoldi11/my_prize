defmodule MyPrize.BussinessTest do
  use MyPrize.DataCase, async: true

  alias MyPrize.Bussiness
  alias MyPrize.Prizes

  describe "new_account/1" do
    test "new_account creates a new account with valid attributes" do
      attrs = %{"email" => "email@email.com", "name" => "Test User"}
      assert {:ok, _account} = Bussiness.new_account(attrs)
    end

    test "new_account returns error if account with email already exists" do
      attrs = %{"email" => "email@email.com", "name" => "Test User"}
      {:ok, _} = Bussiness.new_account(attrs)
      assert {:error, "Account with this email already exists"} = Bussiness.new_account(attrs)
    end
  end

  describe "new_prize/1" do
    test "new_prize creates a new prize with valid attributes" do
      attrs = %{"name" => "Test Prize", "expiration_date" => Date.utc_today() |> Date.add(10)}

      {:ok, account} =
        Bussiness.new_account(%{"email" => "email@email.com.br", "name" => "Test User"})

      attrs = Map.put(attrs, "account_owner_id", account.id)
      assert {:ok, prize} = Bussiness.new_prize(attrs)
      assert prize.name == "Test Prize"
      assert prize.account_owner_id == account.id
    end

    test "new_prize returns error if prize with name already exists for the account owner" do
      attrs = %{"name" => "Test Prize", "expiration_date" => Date.utc_today() |> Date.add(10)}

      {:ok, account} =
        Bussiness.new_account(%{"email" => "email@email.com.br", "name" => "Test User"})

      attrs = Map.put(attrs, "account_owner_id", account.id)
      {:ok, _} = Bussiness.new_prize(attrs)

      assert {:error, "Prize with this name already exists for the account owner"} =
               Bussiness.new_prize(attrs)
    end
  end

  describe "apply_for_prize/2" do
    test "apply_for_prize allows an account to apply for a prize" do
      {:ok, owner} =
        Bussiness.new_account(%{"email" => "owner@email.com.br", "name" => "Owner User"})

      {:ok, account} =
        Bussiness.new_account(%{"email" => "email@email.com.br", "name" => "Test User"})

      {:ok, prize} =
        Bussiness.new_prize(%{
          "name" => "Test Prize",
          "expiration_date" => Date.utc_today() |> Date.add(10),
          "account_owner_id" => owner.id
        })

      assert {:ok, _} = Bussiness.apply_for_prize(account.id, prize.id)
      updated_prize = Prizes.get_prize(prize.id)
      assert prize.id == updated_prize.id
      assert account.id in updated_prize.accounts_applied
    end

    test "apply_for_prize returns error if prize does not exist" do
      {:ok, account} =
        Bussiness.new_account(%{"email" => "email@email.com.br", "name" => "Test User"})

      assert {:error, "Prize not found"} =
               Bussiness.apply_for_prize(account.id, "non_existent_prize_id")
    end

    test "apply_for_prize returns error if account has already applied for the prize" do
      {:ok, owner} =
        Bussiness.new_account(%{"email" => "owner@email.com.br", "name" => "Owner User"})

      {:ok, account} =
        Bussiness.new_account(%{"email" => "email@email.com.br", "name" => "Test User"})

      {:ok, prize} =
        Bussiness.new_prize(%{
          "name" => "Test Prize",
          "expiration_date" => Date.utc_today() |> Date.add(10),
          "account_owner_id" => owner.id
        })

      {:ok, _} = Bussiness.apply_for_prize(account.id, prize.id)

      assert {:error, "Account already applied for this prize"} =
               Bussiness.apply_for_prize(account.id, prize.id)
    end
  end

  describe "raffle_prize/1" do
    test "raffle_prize raffles a prize and assigns a winner" do
      {:ok, owner} =
        Bussiness.new_account(%{"email" => "owner@email.com.br", "name" => "Owner User"})
      {:ok, account} =
        Bussiness.new_account(%{"email" => "email@email.com.br", "name" => "Test User"})

      {:ok, prize} =
        Bussiness.new_prize(%{
          "name" => "Test Prize",
          "expiration_date" => Date.utc_today() |> Date.add(10),
          "account_owner_id" => owner.id
        })

      {:ok, _} = Bussiness.apply_for_prize(account.id, prize.id)
      assert {:ok, _} = Bussiness.raffle_prize(prize.id)
      updated_prize = Prizes.get_prize(prize.id)
      assert updated_prize.raffle_winner_id == account.id
    end

    test "raffle_prize returns error if prize does not exist" do
      non_existent_prize_id = Ecto.UUID.generate()
      assert {:error, "Prize not found"} = Bussiness.raffle_prize(non_existent_prize_id)
    end
  end

  describe "prize_result/1" do
    test "prize_result returns the winner of a prize if it has been raffled" do
      {:ok, owner} =
        Bussiness.new_account(%{"email" => "owner@email.com.br", "name" => "Owner User"})

      {:ok, account} =
        Bussiness.new_account(%{"email" => "email@email.com.br", "name" => "Test User"})

      {:ok, prize} =
        Bussiness.new_prize(%{
          "name" => "Test Prize",
          "expiration_date" => Date.utc_today() |> Date.add(10),
          "account_owner_id" => owner.id
        })

      {:ok, _} = Bussiness.apply_for_prize(account.id, prize.id)
      {:ok, _} = Bussiness.raffle_prize(prize.id)
      assert {:ok, %{prize: _prize, winner: winner}} = Bussiness.prize_result(prize.id)
      assert winner.id == account.id
    end

    test "prize_result returns error if prize has not been raffled" do
      {:ok, owner} =
        Bussiness.new_account(%{"email" => "owner@email.com.br", "name" => "Owner User"})

      {:ok, account} =
        Bussiness.new_account(%{"email" => "email@email.com.br", "name" => "Test User"})

      {:ok, prize} =
        Bussiness.new_prize(%{
          "name" => "Test Prize",
          "expiration_date" => Date.utc_today() |> Date.add(10),
          "account_owner_id" => owner.id
        })

      {:ok, _} = Bussiness.apply_for_prize(account.id, prize.id)
      assert {:error, "Prize has not been raffled yet"} = Bussiness.prize_result(prize.id)
    end
  end
end
