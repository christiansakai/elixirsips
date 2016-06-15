defmodule ListSubSupervisor do
  use Supervisor

  def start_link(list_data) do
    Supervisor.start_link(__MODULE__, list_data)
  end

  def init(list_data) do
    child_processes = [
      worker(ListServer, [list_data])
    ]

    supervise(child_processes, strategy: :one_for_one)
  end
end
