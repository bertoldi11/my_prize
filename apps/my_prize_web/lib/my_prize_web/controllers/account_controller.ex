defmodule MyPrizeWeb.Controllers.AccountController do
  use MyPrizeWeb, :controller
  alias MyPrize.Bussiness

  action_fallback MyPrizeWeb.Controllers.FallbackController

  def new(conn, params) do
    with {:ok, account} <- Bussiness.new_account(params) do
      json(conn, %{status: "success", account: account})
    end
  end
end
