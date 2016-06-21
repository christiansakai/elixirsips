defmodule Ledger.Account do
  alias Ledger.Credit
  alias Ledger.Debit

  defstruct [
    type: nil,
    debits: [],
    credits: []
  ]

  @typedoc """
  An account can be either `:debit` or `:credit`.
  """
  @type account_type :: :debit | :credit

  @typedoc """
  A Ledger Account has a `type`, `debit` and `credit`.
  """
  @type t :: %__MODULE__{
    type: account_type,
    debits: list(Debit.t),
    credits: list(Credit.t)
  }

  def debit(account = %__MODULE__{debits: debits}, amount) do
    %__MODULE__{account |
      debits: [%Debit{amount: amount} | debits]
    }
  end

  def credit(account = %__MODULE__{credits: credits}, amount) do
    %__MODULE__{account | 
     credits: [%Credit{amount: amount} | credits]
   }
  end

  def debits_sum(%__MODULE__{debits: debits}) do
    Enum.reduce(debits, Decimal.new(0), fn(debit, acc) ->
      Decimal.add(debit.amount, acc)
    end)
  end

  def credits_sum(%__MODULE__{credits: credits}) do
    Enum.reduce(credits, Decimal.new(0), fn(credit, acc) ->
      Decimal.add(credit.amount, acc)
    end)
  end
end

