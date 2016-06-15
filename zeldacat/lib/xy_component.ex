defmodule XYComponent do
  use GenEvent

  ####
  # Public API
  def get_position(entity) do
    GenEvent.call(entity, __MODULE__, :get_position)
  end
  

  ####
  # GenEvent API
  def init(position) do
    {:ok, position}
  end

  def handle_event({:move, {:y, amount}}, {x, _y}) do
    {:ok, {x, amount}}
  end

  def handle_event({:move, {:x, amount}}, {_x, y}) do
    {:ok, {amount, y}}
  end

  def handle_call(:get_position, position) do
    {:ok, position, position}
  end
end
