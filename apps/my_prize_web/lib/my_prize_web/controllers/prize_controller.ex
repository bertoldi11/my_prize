defmodule MyPrizeWeb.Controllers.PrizeController do
  use MyPrizeWeb, :controller
  alias MyPrize.Bussiness

  def new(conn, params) do
    case Bussiness.new_prize(params) do
      {:ok, prize} ->
        json(conn, %{status: "success", prize: prize})

      {:error, reason} ->
        json(conn, %{status: "error", reason: reason})
    end
  end

  def applay(conn, params) do
    account_id = params["account_id"]
    prize_id = params["prize_id"]

    case Bussiness.apply_for_prize(account_id, prize_id) do
      {:ok, prize} ->
        json(conn, %{status: "success", prize: prize})

      {:error, reason} ->
        json(conn, %{status: "error", reason: reason})
    end
  end

  def result(conn, params) do
    prize_id = params["prize_id"]

    case Bussiness.prize_result(prize_id) do
      {:ok, result} ->
        json(conn, %{status: "success", result: result})

      {:error, reason} ->
        json(conn, %{status: "error", reason: reason})
    end
  end
end
