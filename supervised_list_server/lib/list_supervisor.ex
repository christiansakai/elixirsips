defmodule ListSupervisor do
  use Supervisor

  def start_link do
    result = {:ok, supervisor} = Supervisor.start_link(__MODULE__, [])
    start_workers(supervisor)
    result
  end

  def start_workers(supervisor) do
    # Start the ListData worker
    {:ok, list_data} = Supervisor.start_child(supervisor, worker(ListData,[])) 

    # Start the SubSupervisor for the actual list server
    Supervisor.start_child(supervisor, worker(ListSubSupervisor, [list_data]))
  end

  def init(list) do
    supervise([], strategy: :one_for_one)
  end
end
