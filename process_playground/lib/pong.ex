defmodule Pong do

  def start do
    await(0)
  end

  def await(count) do
    receive do
      {:ping, pid} ->
        send pid, {:pong, self}
        IO.puts "Pong received #{count}"
        await(count + 1)
    end
  end
end


