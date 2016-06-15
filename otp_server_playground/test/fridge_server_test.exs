defmodule FridgeServer do
  use GenServer

  #####
  # Public API
  def start_link(items) do
    {:ok, fridge} = GenServer.start_link(__MODULE__, items)
    fridge
  end

  def store(fridge, item) do
    GenServer.call(fridge, {:store, item})
  end

  def take(fridge, item) do
    GenServer.call(fridge, {:take, item})
  end

  #####
  # GenServer API
  def init(items) do
    {:ok, items}
  end

  def handle_call({:store, item}, _from, items) do
    {:reply, :ok, [item | items]}
  end

  def handle_call({:take, item}, _from, items) do
    index = 
      items
      |> Enum.find_index(fn el -> el == item end)

    case index do
      nil -> 
        {:reply, :not_found, items}
      index when is_integer(index) -> 
        {:reply, item, items -- [item]}
    end
  end
end

defmodule FridgeServerTest do
  use ExUnit.Case

  test "putting something into the fridge" do
    fridge = FridgeServer.start_link([])
    assert :ok = FridgeServer.store(fridge, :bacon)
  end

  test "removing something from the fridge" do
    fridge = FridgeServer.start_link([])
    FridgeServer.store(fridge, :bacon)
    assert :bacon = FridgeServer.take(fridge, :bacon)
  end

  test "taking something from the fridge that isn't in there" do
    fridge = FridgeServer.start_link([])
    assert :not_found = FridgeServer.take(fridge, :bacon)
  end
end
