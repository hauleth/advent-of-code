defmodule Main do
  def calculate(value), do: max(div(value, 3) - 2, 0)

  def for_fuel(value), do: for_fuel(value, value)

  defp for_fuel(0, total), do: total
  defp for_fuel(value, total) do
    current = calculate(value)

    for_fuel(current, total + current)
  end
end

IO.stream(:stdio, :line)
|> Stream.map(&String.to_integer(String.trim(&1)))
|> Stream.map(&Main.calculate/1)
|> Stream.map(&Main.for_fuel/1)
|> Enum.reduce(&+/2)
|> IO.inspect()
