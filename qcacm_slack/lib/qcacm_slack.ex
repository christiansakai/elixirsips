defmodule QcacmSlack do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Define workers and child supervisors to be supervised
      worker(QcacmSlack.Bot, [Application.get_env(:qcacm_slack, :key), []])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: QcacmSlack.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
