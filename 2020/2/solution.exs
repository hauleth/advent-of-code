defmodule Solution do
  def read(path) do
    path
    |> File.stream!()
    |> Enum.map(&String.trim/1)
    |> Enum.map(&parse/1)
  end

  defp parse(input) do
    [spec, pass] = String.split(input, ": ", parts: 2)
    [range, <<char>>] = String.split(spec, " ", parts: 2)
    [min, max] =
      range
      |> String.split("-", parts: 2)
      |> Enum.map(&String.to_integer/1)

    {min..max, char, pass}
  end

  def validate_1({range, char, pass}) do
    count = for <<^char <- pass>>, reduce: 0, do: (n -> n + 1)

    count in range
  end

  def validate_2({a..b, char, pass}) do
    <<char_1>> = binary_part(pass, a - 1, 1)
    <<char_2>> = binary_part(pass, b - 1, 1)

    char_1 != char_2 and char in [char_1, char_2]
  end
end

data = Solution.read("2/input.txt")

IO.inspect(Enum.count(data, &Solution.validate_1/1), label: "task 1")
IO.inspect(Enum.count(data, &Solution.validate_2/1), label: "task 2")
