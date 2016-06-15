defmodule HealthComponent do
  use GenEvent

  ####
  # Public API
  def get_hp(entity) do
    GenEvent.call(entity, __MODULE__, :get_hp)
  end

  def alive?(entity) do
    GenEvent.call(entity, __MODULE__, :alive?)
  end

  ####
  # GenEvent API
  def init(hp) do
    {:ok, hp}
  end

  def handle_event({:hit, amount}, hp) do
    {:ok, hp - amount}
  end

  def handle_event({:heal, amount}, hp) do
    {:ok, hp + amount}
  end

  def handle_call(:get_hp, hp) do
    {:ok, hp, hp}
  end

  def handle_call(:alive?, hp) do
    if hp > 0 do
      {:ok, true, hp}
    else
      {:ok, false, hp}
    end
  end
end
