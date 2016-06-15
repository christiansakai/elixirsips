require IEx

defmodule IexPryTest do
  use Application

  def start(_type, _args) do
    IexPryTest.Supervisor.start_link
  end

  def add(a, b) do
    c = a + b
    IEx.pry 
    c
  end

end
