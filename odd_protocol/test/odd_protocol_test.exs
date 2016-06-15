defprotocol Odd do
  @fallback_to_any true

  @doc "Returns true if data is considered odd"
  def odd?(data)
end

defimpl Odd, for: Any do
  def odd?(_), do: false
end

defimpl Odd, for: Integer do
  require Integer
  def odd?(num) do
    Integer.is_odd(num)
  end
end

defimpl Odd, for: Float do
  require Integer

  def odd?(num) do
    num
    |> Float.floor
    |> round
    |> Integer.is_odd
  end
end

defmodule Animal do
  defstruct hairy: false, leg_count: 4
end

defimpl Odd, for: Animal do
  def odd?(%Animal{hairy: true}), do: true
  def odd?(_), do: false
end

defimpl Odd, for: List do
  def odd?(list) do
    list
    |> Enum.count
    |> Odd.odd?
  end
end

defmodule OddProtocolTest do
  use ExUnit.Case
  doctest OddProtocol

  test "integers know if they're odd" do
    assert Odd.odd? 1
    refute Odd.odd? 2
  end

  test "floats are odd if their floor is" do
    assert Odd.odd? 1.1
    assert Odd.odd? 1.9
    refute Odd.odd? 2.1
  end

  test "lists are odd if they have an odd number of elements" do
    refute Odd.odd? []
    assert Odd.odd? [1]
  end

  test "animals are odd if they're hairy" do
    assert Odd.odd? %Animal{hairy: true}
    refute Odd.odd? %Animal{hairy: false}
  end

  test "unspecified things aren't odd" do
    refute Odd.odd? %{}
    refute Odd.odd? "jabow"
    refute Odd.odd? :poland
  end
end
