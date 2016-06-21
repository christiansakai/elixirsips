defmodule Agenda.Parser do
  def parse(schedule_string) do
    [minute, 
     hour,
     day_of_month,
     month,
     day_of_week |
     command] = String.split(schedule_string, " ")

    command = 
      command
      |> Enum.join
      |> Code.string_to_quoted!

    parse(parse_pattern(minute, 0..59), 
          parse_pattern(hour, 0..23), 
          parse_pattern(day_of_month, 1..31), 
          parse_pattern(month, 1..12), 
          parse_pattern(day_of_week, 0..6), 
          command)
  end

  def parse(minute, hour, day_of_month, month, day_of_week, command) do
    %Agenda.Schedule{
      minute: minute,
      hour: hour,
      day_of_month: day_of_month,
      month: month,
      day_of_week: day_of_week,
      command: command
    }
  end

  def parse_pattern("*/" <> modulo, range) do
    modulo = String.to_integer(modulo)
    Enum.filter(range, fn el ->
      rem(el, modulo) == 0
    end)
  end

  def parse_pattern("*", range) do
    range
    |> Enum.to_list
  end

  def parse_pattern(string, _range) do
    string
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end
end
