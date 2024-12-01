defmodule GravAssist do
  def calc([op, _, _ | rest], a \\ 12, b \\ 2) do
    hd(execute([op, a, b | rest]))
  end

  def execute(bytecode) when is_list(bytecode), do: execute(:array.from_list(bytecode))
  def execute(bytecode), do: eval(bytecode, 0)

  defp eval(bytecode, ic) do
    case :array.get(ic, bytecode) do
      99 -> :array.to_list(bytecode)
      op when op in 1..2 ->
        pos_a = :array.get(ic + 1, bytecode)
        pos_b = :array.get(ic + 2, bytecode)
        pos_r = :array.get(ic + 3, bytecode)

        result = compute(op, :array.get(pos_a, bytecode), :array.get(pos_b, bytecode))

        new_bc = :array.set(pos_r, result, bytecode)

        eval(new_bc, ic + 4)
      _ -> :error
    end
  end

  defp compute(1, a, b), do: a + b
  defp compute(2, a, b), do: a * b
end

data =
  IO.read(:line)
  |> String.split(",")
  |> Enum.map(&String.to_integer(String.trim(&1)))

IO.inspect(GravAssist.calc(data), label: :sol1)

for(a <- 0..99,
    b <- 0..99,
    19690720 == GravAssist.calc(data, a, b),
  do: {a, b})
|> IO.inspect(label: :sol2)
