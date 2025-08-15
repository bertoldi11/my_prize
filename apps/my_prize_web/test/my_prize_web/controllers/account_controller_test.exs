defmodule MyPrizeWeb.Controllers.AccountControllerTest do
  use MyPrizeWeb.ConnCase, async: true

  @create_attrs %{
    email: "email@email.com.br",
    name: "Test User",
  }

  @invalid_attrs %{email: nil, name: nil}

  describe "create account" do
    test "renders account when data is valid", %{conn: conn} do
      conn = post(conn, Routes.account_path(conn, :create), account: @create_attrs)
      assert %{status: "success", account: account} = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.account_path(conn, :create), account: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
