defmodule ListServer do
  use GenServer

  ####
  # Public API
  def start_link(list_data) do
    GenServer.start_link(__MODULE__, list_data, name: __MODULE__)
  end

  def clear do
    GenServer.cast(__MODULE__, :clear)
  end

  def items do
    GenServer.call(__MODULE__, :items)
  end

  def add(item) do
    GenServer.cast(__MODULE__, {:add, item}) 
  end

  def remove(item) do
    GenServer.cast(__MODULE__, {:remove, item})
  end

  def crash do
    GenServer.cast(__MODULE__, :crash)
  end

  ####
  # GenServer API
  def init(list_data) do
    items = ListData.get_state(list_data)
    {:ok, {items, list_data}}
  end

  def handle_cast(:clear, {_items, list_data}) do
    {:noreply, {[], list_data}}
  end

  def handle_cast({:add, item}, {items, list_data}) do
    {:noreply, {[item | items], list_data}}
  end

  def handle_cast({:remove, item}, {items, list_data}) do
    {:noreply, {items -- [item], list_data}}
  end

  def handle_cast(:crash, _items) do
    1 = 2
  end

  def handle_call(:items, _from, {items, list_data}) do
    {:reply, items, {items, list_data}}
  end

  #### Handle termination
  def terminate(_reason, {list, list_data}) do
    ListData.save_state(list_data, list)
  end

end
