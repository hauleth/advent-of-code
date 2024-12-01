defmodule Wires do
  @directions %{
    ?U => :up,
    ?D => :down,
    ?R => :right,
    ?L => :left
  }

  @moves %{
    up: {0, 1},
    down: {0, -1},
    right: {1, 0},
    left: {-1, 0}
  }

  def load(list) do
    list
    |> Enum.map(&parse/1)
    |> wire()
  end

  defp parse(<<c, rest::binary>>) do
    {Map.fetch!(@directions, c), String.to_integer(rest)}
  end

  defp wire(steps) do
    steps
    |> Enum.reduce({[], {0, 0}}, &into_coordinates/2)
    |> elem(0)
    |> MapSet.new()
  end

  defp into_coordinates({_, 0}, {points, curr}), do: {[curr | points], curr}
  defp into_coordinates({dir, n}, {points, {x, y}}) do
    {dx, dy} = Map.fetch!(@moves, dir)
    next = {x + dx, y + dy}

    into_coordinates({dir, n - 1}, {[next | points], next})
  end
end

w1 =
  IO.read(:line)
  |> String.trim()
  |> String.split(",")
  |> Wires.load()
w2 =
  IO.read(:line)
  |> String.trim()
  |> String.split(",")
  |> Wires.load()

MapSet.intersection(w1, w2)
|> MapSet.to_list()
|> Enum.map(fn {x, y} -> abs(x) + abs(y) end)
|> Enum.min()
|> IO.inspect()
