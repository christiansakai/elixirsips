defmodule Ledger.Credit do
  defstruct [amount: nil]

  @type t :: %__MODULE__{
    amount: Decimal.t
  }
end
