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
end
