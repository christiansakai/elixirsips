defmodule Ledger.JournalEntry do
  alias Ledger.Credit
  alias Ledger.Debit

  defstruct [
    created_at: nil,
    description: nil,
    items: []
  ]

  @type t :: %__MODULE__{
    created_at: {{integer, integer, integer}, {integer, integer, integer}},
    description: String.t,
    items: list(%Credit{} | %Debit{})
  }

  @spec total(__MODULE__.t) :: %{debit: %Debit{}, credit: %Credit{}}
  def total(%__MODULE__{items: items}) do
    debit = %Debit{amount: Decimal.new(0)}
    credit = %Credit{amount: Decimal.new(0)}

    items
    |> Enum.reduce(%{debit: debit, credit: credit}, fn
      %Debit{amount: amount}, acc ->
        %{acc |
          debit: %Debit{acc.debit | amount: Decimal.add(acc.debit.amount, amount)}}
      %Credit{amount: amount}, acc ->
        %{acc |
          credit: %Credit{acc.credit | amount: Decimal.add(acc.credit.amount, amount)}}
    end)
  end

  @spec balanced?(__MODULE__.t) :: boolean
  def balanced?(journal_entry = %__MODULE__{}) do
    %{debit: debit, credit: credit} = 
      journal_entry
      |> total

      debit.amount == credit.amount
  end
end
