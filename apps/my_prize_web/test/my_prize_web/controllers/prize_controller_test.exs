defmodule  MyPrizeWeb.Controllers.PrizeControllerTetst do
  use MyPrizeWeb.ConnCase
  alias MyPrize.Bussiness

  @create_attrs %{
    "name" => "Sample Prize",
    "description" => "This is a sample prize description.",
    "account_owner_id" => nil,
    "expiration_date" => "2027-12-31"
  }

  @invalid_create_attrs %{
    "name" => "",
    "description" => "This is a sample prize description.",
    "account_owner_id" => nil,
    "expiration_date" => nil
  }

  describe "create prize" do
    test "creates a new prize and returns it", %{conn: conn} do
      {:ok, user} = Bussiness.new_account(%{"name" => "Test User", "email" => "email@email.com.br"})
      create_attrs = Map.put(@create_attrs, "account_owner_id", user.id)

      conn = post(conn, "/api/prize", create_attrs)
      assert %{"status" => "success", "prize" => prize} = json_response(conn, 200)
      assert prize["name"] == "Sample Prize"
      assert prize["description"] == "This is a sample prize description."
    end

    test "fails to create a prize with invalid data", %{conn: conn} do
      conn = post(conn, "/api/prize", @invalid_create_attrs)
      assert %{"errors" => _} = json_response(conn, 422)
    end
  end

  describe "apply for prize" do
    test "applies for a prize successfully", %{conn: conn} do
      {:ok, user} = Bussiness.new_account(%{"name" => "Test User", "email" => "email@email.com.br"})
      {:ok, prize} = Bussiness.new_prize(Map.put(@create_attrs, "account_owner_id", user.id))
      apply_attrs = %{"account_id" => user.id, "prize_id" => prize.id}
      conn = post(conn, "/api/prize/apply", apply_attrs)
      assert %{"status" => "success", "application" => _application} = json_response(conn, 200)
    end

    test "fails to apply for a non-existent prize", %{conn: conn} do
      apply_attrs = %{"account_id" => Ecto.UUID.generate(), "prize_id" => Ecto.UUID.generate()}
      conn = post(conn, "/api/prize/apply", apply_attrs)
      assert %{"errors" => %{"detail" => "Prize not found"}} = json_response(conn, 400)
    end
  end

  describe "get prize result" do
    test "retrieves the result of a prize", %{conn: conn} do
      {:ok, user} = Bussiness.new_account(%{"name" => "Test User", "email" => "owner@email.com.br"})
      {:ok, prize} =
        @create_attrs
        |> Map.put("account_owner_id", user.id)
        |> Bussiness.new_prize()

      {:ok, result} = Bussiness.prize_result(prize.id)
      conn = get(conn, "/api/prize/result/#{prize.id}")
      assert %{"status" => "success", "result" => ^result} = json_response(conn, 200)
    end
  end
end
