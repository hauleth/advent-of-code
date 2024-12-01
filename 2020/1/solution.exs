defmodule Solution do
  def load(path) do
    path
    |> File.stream!()
    |> Stream.map(&String.to_integer(String.trim(&1)))
    |> Enum.to_list()
  end

  def run([], _, _), do: nil
  def run(_, _, sum) when sum < 0, do: nil
  def run([a | _], 1, a), do: [a]

  def run([a | rest], n, sum) do
    case run(rest, n - 1, sum - a) do
      nil -> run(rest, n, sum)
      nums when is_list(nums) -> [a | nums]
    end
  end
end

list = Solution.load("./1/input.txt")

list
|> Solution.run(2, 2020)
|> Enum.reduce(&*/2)
|> IO.inspect(label: "task 1")

list
|> Solution.run(3, 2020)
|> Enum.reduce(&*/2)
|> IO.inspect(label: "task 2")

Benchee.run(%{
  "first solution" => fn ->
    try do
      for x <- list, y <- list, z <- list, x + y + z == 2020 do
        throw(x * y * z)
      end

      :error
    catch
      num -> {:ok, num}
    end
  end,
  "optimized" => fn ->
    try do
      for x <- list,
          rest = 2020 - x,
          y <- list,
          y < rest,
          rest = 2020 - x - y,
          z <- list,
          z <= rest,
          x + y + z == 2020,
          do: throw(x * y * z)

      :error
    catch
      num -> {:ok, num}
    end
  end,
  "mine" => fn ->
    Solution.run(list, 3, 2020)
  end
})
