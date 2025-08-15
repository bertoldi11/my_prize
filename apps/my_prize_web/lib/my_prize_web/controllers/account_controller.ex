defmodule MyPrizeWeb.Controllers.AccountController do
  use MyPrizeWeb, :controller
  alias MyPrize.Bussiness

  def new(conn, params) do
    case Bussiness.new_account(params) do
      {:ok, account} ->
        json(conn, %{status: "success", account: account})

      {:error, reason} ->
        json(conn, %{status: "error", reason: reason})
    end
  end
end
