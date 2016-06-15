defmodule Schizo do
  @moduledoc """
  A nice module that lets you uppercase or unvowel every other letter in a sentence.
  """

  @doc """
  Uppercases every other word in a sentece.

  ## Example
      iex> Schizo.uppercase("you are silly")
      "you ARE silly"
  """
  def uppercase(string) do
    transform_every_other(string, &uppercaser/1)
  end

  @doc """
  Removes vowels from every other word in a sentence.

  ## Example
      iex> Schizo.unvowel("you are silly")
      "you r silly"
  """
  def unvowel(string) do
    transform_every_other(string, &unvoweler/1)
  end

  def transform_every_other(string, transformer) do
    string
    |> String.split(" ")
    |> Stream.with_index
    |> Stream.map(transformer)
    |> Enum.join(" ")
  end

  def uppercaser({value, index}) when rem(index, 2) == 0, do: value
  def uppercaser({value, index}) when rem(index, 2) == 1, do: String.upcase(value)

  def unvoweler({value, index}) when rem(index, 2) == 0, do: value
  def unvoweler({value, index}) when rem(index, 2) == 1 do
    Regex.replace(~r/[aeiou]/, value, "")
  end

end
