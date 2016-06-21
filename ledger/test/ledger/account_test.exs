defmodule Ledger.AccountTest do
  use ExUnit.Case
  alias Ledger.Account

  @credit_account %Account{type: :credit}
  @debit_account %Account{type: :debit}

  test "Accounts can be either debit or credit account" do
    assert :debit == @debit_account.type
    assert :credit == @credit_account.type  
  end

  test "Accounts have debits and credits" do
    account = 
      @credit_account
      |> Account.debit(Decimal.new(5))
      |> Account.credit(Decimal.new(10))

    assert Decimal.new(5) == Account.debits_sum(account)
    assert Decimal.new(10) == Account.credits_sum(account)
  end
end
