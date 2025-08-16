defmodule MyPrizeWeb.Controllers.PrizeController do
  use MyPrizeWeb, :controller
  alias MyPrize.Bussiness

  action_fallback MyPrizeWeb.Controllers.FallbackController

  def create(conn, params) do
    with {:ok, prize} <- Bussiness.new_prize(params) do
      json(conn, %{status: "success", prize: prize})
    end
  end

  def applay(conn, params) do
    account_id = params["account_id"]
    prize_id = params["prize_id"]

    with {:ok, application} <- Bussiness.apply_for_prize(account_id, prize_id) do
      json(conn, %{status: "success", application: application})
    end
  end

  def result(conn, params) do
    prize_id = params["prize_id"]

    with {:ok, result} <- Bussiness.prize_result(prize_id) do
      json(conn, %{status: "success", result: result})
    end
  end
end
