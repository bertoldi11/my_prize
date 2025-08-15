defmodule MyPrize.Prizes do
  @moduledoc """
  The Prizes context for MyPrize, managing prize-related operations and interactions
  with the database.
  """

  alias MyPrize.Prizes.Schemas.Prizes
  alias MyPrize.Repo

  @doc """
  Creates a new prize with the given attributes.
  """
  def create_prize(attrs) do
    %Prizes{}
    |> Prizes.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Retrieves all prizes from the database.
  """
  def list_prizes do
    Repo.all(Prizes)
  end

  @doc """
  Finds a prize by its ID.
  """
  def get_prize(id) do
    Repo.get(Prizes, id)
  end

  @doc """
  Updates a prize with the given ID and attributes.
  """
  def update_prize(id, attrs) do
    prize = get_prize(id)
    case prize do
      nil -> {:error, "Prize not found"}
      _ ->  prize
            |> Prizes.changeset(attrs)
            |> Repo.update()
    end
  end
end
