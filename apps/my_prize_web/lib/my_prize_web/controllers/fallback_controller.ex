defmodule MyPrizeWeb.Controllers.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.
  See `Phoenix.Controller.action_fallback/1` for more details
  """
  use MyPrizeWeb, :controller

  alias MyPrizeWeb.ErrorView
  alias Ecto.Changeset
  alias Plug.Conn

  import Phoenix.Controller, only: [put_view: 2, render: 3]

  @doc """
  Handles errors returned by Ecto's insert/update/delete.
  """
  def call(conn, {:error, %Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ErrorView)
    |> render("422.json", changeset: changeset)
  end

  def call(conn, {:error, message}) when is_binary(message) do
    conn
    |> put_status(:bad_request)
    |> put_view(ErrorView)
    |> render("400.json", message: message)
  end
end
