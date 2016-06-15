defmodule ListData do
  use GenServer

  #### Public API
  def start_link do
    GenServer.start_link(__MODULE__, [], [])
  end

  def save_state(list_data, state) do
    GenServer.cast(list_data, {:save_state, state})  
  end

  def get_state(list_data) do
    GenServer.call(list_data, :get_state)
  end

  #### GenServer API
  def init(list) do
    {:ok, list}
  end

  def handle_call(:get_state, _from, list) do
    {:reply, list, list}
  end

  def handle_cast({:save_state, new_list}, _list) do
    {:noreply, new_list}
  end

end
