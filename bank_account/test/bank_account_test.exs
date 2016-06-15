defmodule BankAccount do
  def start do
    await([])
  end

  def await(events) do
    receive do
      {:check_balance, pid} ->
        divulge_balance(pid, events)
      {:deposit, amount} ->
        events = deposit(amount, events)
      {:withdraw, amount} ->
        events = withdraw(amount, events)
    end

    await(events)
  end

  defp deposit(amount, events) do
    events ++ [{:deposit, amount}]
  end

  defp withdraw(amount, events) do
    events ++ [{:withdraw, amount}]
  end

  defp divulge_balance(pid, events) do
    send pid, {:balance, calculate_balance(events)}
  end

  defp calculate_balance(events) do
    deposits = sum(events)
    deposits
  end

  defp sum(events) do
    Enum.reduce(events, 0, fn
      {:deposit, amount}, acc ->
        acc + amount 
      {:withdraw, amount}, acc ->
        acc - amount
    end)
  end
end

defmodule BankAccountTest do
  use ExUnit.Case
  doctest BankAccount
  
  test "starts off with a balance of 0" do
    account = spawn_link(BankAccount, :start, [])
    verify_balance_is 0, account
  end

  test "has balance incremented by the amount of a deposit" do
    account = spawn_link(BankAccount, :start, [])
    send account, {:deposit, 10}
    verify_balance_is 10, account
  end

  test "has balance decremented by the amount of withdrawals" do
    account = spawn_link(BankAccount, :start, [])
    send account, {:deposit, 20}
    send account, {:withdraw, 10}
    verify_balance_is 10, account
  end

  def verify_balance_is(expected, account) do
    send account, {:check_balance, self}
    assert_receive {:balance, ^expected}
  end

end
