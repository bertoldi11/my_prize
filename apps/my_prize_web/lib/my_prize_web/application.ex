defmodule MyPrizeWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MyPrizeWeb.Telemetry,
      # Start a worker by calling: MyPrizeWeb.Worker.start_link(arg)
      # {MyPrizeWeb.Worker, arg},
      # Start to serve requests, typically the last entry
      MyPrizeWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MyPrizeWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MyPrizeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
