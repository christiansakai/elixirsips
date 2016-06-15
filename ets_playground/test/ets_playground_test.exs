defmodule EtsPlaygroundTest do
  use ExUnit.Case
  @dets_file "cars.dets"

  setup do
    :ets.new(:ets_cars, [:set, :named_table])

    :ets_cars
    |> :ets.insert({"328i", "BMW", "White", 2011, 5})

    :ets_cars
    |> :ets.insert({"335i", "BMW", "White", 2011, 6})

    :ets_cars
    |> :ets.insert({"528i", "BMW", "White", 2012, 4})

    {:ok, _} = :dets.open_file(:cars, [file: @dets_file, type: :set])

    :dets.from_ets(:cars, :ets_cars)

    on_exit fn ->
      :dets.close(:cars)
      File.rm(@dets_file)
      :ok
    end

    :ok
  end

  test "creatinga  table and getting its info" do
    info = :dets.info(:cars)
    assert info[:type] == :set
  end

  test "inserting and retrieving data" do
    IO.inspect :dets.lookup(:cars, "328i")
    [{_model, maker, _color, _year, _count}] = :dets.lookup(:cars, "328i")
    assert maker == "BMW"
  end

  test "traversing the table sequentially" do
    first = :dets.first(:cars)
    second = :dets.next(:cars, first)
    third = :dets.next(:cars, second)

    assert third = "528i"
    assert :"$end_of_table" == :dets.next(:cars, third)
  end

  test "querying the table for data that matches a pattern" do
    query = {:_, :_, :_, 2012, :_}
    cars_from_2012 = :dets.match_object(:cars, query)
    [{model, _, _, _, _}] = cars_from_2012
    assert model == "528i"
  end

  test "querying using match specs" do
    query = [
      {
        {:_, :_, :_, :"$1", :_},
        [{:andalso,
          {:'>=', :"$1", 2011},
          {:'=<', :"$1", 2012}
        }],
      [:"$_"]
      }
    ]

    selected_cars = :dets.select(:cars, query)
    assert Enum.count(selected_cars) == 3
  end

  test "updating a counter" do
    [{_, _, _, _, count}] = :dets.lookup(:cars, "328i")
    assert count == 5
    :dets.update_counter(:cars, "328i", {5, 3})
    [{_, _, _, _, count}] = :dets.lookup(:cars, "328i")
    assert count == 8
  end

end
