defmodule Entity do
  use GenEvent

  ####
  # Public API
  def init do
    GenEvent.start_link()
  end

  def add_component(entity, component, arg) do
    GenEvent.add_handler(entity, component, arg)
  end

  def notify(entity, event) do
    GenEvent.notify(entity, event)
  end
end
