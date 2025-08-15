defmodule PrizeTest do
  use ExUnit.Case
  doctest Prize

  test "greets the world" do
    assert Prize.hello() == :world
  end
end
