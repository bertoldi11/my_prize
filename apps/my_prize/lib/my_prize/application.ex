defmodule MyPrize.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MyPrize.Repo,
      {DNSCluster, query: Application.get_env(:my_prize, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: MyPrize.PubSub}
      # Start a worker by calling: MyPrize.Worker.start_link(arg)
      # {MyPrize.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: MyPrize.Supervisor)
  end
end
