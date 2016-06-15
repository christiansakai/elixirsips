defmodule WeaponComponent do
  use GenEvent

  ####
  # Public API
  def list_weapons(entity) do
    GenEvent.call(entity, __MODULE__, :list_weapons)
  end


  ####
  # GenEvent API
  def init(weapons) do
    {:ok, weapons}
  end

  def handle_call(:list_weapons, weapons) do
    {:ok, weapons, weapons}
  end

  def handle_event({:add_weapon, weapon}, weapons) do
    {:ok, weapons ++ [weapon]}
  end
end
