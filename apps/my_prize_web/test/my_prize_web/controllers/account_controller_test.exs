defmodule MyPrizeWeb.Controllers.AccountControllerTest do
  use MyPrizeWeb.ConnCase, async: true

  @create_attrs %{
    email: "email@email.com.br",
    name: "Test User",
  }

  @invalid_attrs %{email: nil, name: nil}

  describe "create account" do
    test "renders account when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/account/new", @create_attrs)
      IO.inspect(conn, label: "Response from account creation")
      assert %{status: "success", account: _account} = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/account/new", @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
