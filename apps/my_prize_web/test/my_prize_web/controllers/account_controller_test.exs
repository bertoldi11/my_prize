defmodule MyPrizeWeb.Controllers.AccountControllerTest do
  use MyPrizeWeb.ConnCase, async: true

  @create_attrs %{
    email: "email@email.com.br",
    name: "Test User",
  }

  @invalid_attrs %{email: nil, name: nil}

  describe "create account" do
    test "renders account when data is valid", %{conn: conn} do
      conn = post(conn, "/api/account", @create_attrs)
      assert %{status: "success", account: _account} = json_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, "/api/account", @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
