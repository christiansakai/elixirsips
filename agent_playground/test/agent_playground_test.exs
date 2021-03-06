defmodule AgentPlaygroundTest do
  use ExUnit.Case
  doctest AgentPlayground

  setup do
    {:ok, _pid} = Agent.start_link(fn ->
      %{}
    end, name: :store)
    :ok
  end

  test "inserting an element" do
    assert :ok == Agent.update(:store, fn x ->
      Map.put(x, :foo, :bar)
    end)
  end

  test "fetching an element" do
    :ok = Agent.update(:store,&Map.put(&1, :foo, :bar))
    assert :bar == Agent.get(:store, fn x -> x[:foo] end)
  end

  test "async casts" do
    :ok = Agent.update(:store, &Map.put(&1, :count, 0))
    increment = &Map.update!(&1, :count, fn x -> x + 1 end)
    Agent.cast(:store, increment)
    Agent.cast(:store, increment)
    Agent.cast(:store, increment)
    assert 3 == Agent.get(:store, fn x -> x[:count] end)
  end

  test "get and udpate in one go" do
    :ok = Agent.update(:store, &Map.put(&1, :count, 0))
    assert 0 = Agent.get_and_update(:store, fn x ->
      {Map.get(x, :count), Map.put(x, :count, x.count + 1)}
    end)
    assert 1 == Agent.get(:store, fn x -> x[:count] end)
  end

end
