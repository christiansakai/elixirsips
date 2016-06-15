defmodule Ping do
  def start do
    receive do
      {:pong, pid} ->
        send pid, {:ping, self}
        start
    end
  end
end


