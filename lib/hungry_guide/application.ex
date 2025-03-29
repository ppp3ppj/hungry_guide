defmodule HungryGuide.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      HungryGuideWeb.Telemetry,
      HungryGuide.Repo,
      {DNSCluster, query: Application.get_env(:hungry_guide, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: HungryGuide.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: HungryGuide.Finch},
      # Start a worker by calling: HungryGuide.Worker.start_link(arg)
      # {HungryGuide.Worker, arg},
      # Start to serve requests, typically the last entry
      HungryGuideWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: HungryGuide.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    HungryGuideWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
