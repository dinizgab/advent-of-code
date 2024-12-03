defmodule Day3 do
  def run do
    reg = ~r/mul\([\d]{1,3},[\d]{1,3}\)/

    input =
      File.read!("inputs/day-3.txt")
      |> (&Regex.scan(reg, &1)).()

    values =
      Enum.map(input, fn inst ->
        tuple =
          inst
          |> hd()
          |> String.trim_leading("mul(")
          |> String.trim_trailing(")")
          |> String.split(",")
          |> Enum.map(fn v -> String.to_integer(v) end)

        tuple
      end)

    result =
      Enum.reduce(values, 0, fn [a, b], acc ->
        acc + a * b
      end)

    IO.puts("Result - Part 1: #{result}")
  end
end

defmodule Day3Part2 do
  def remove_donts([]) do
    :done
  end

  def remove_donts(list) do
    case Enum.find(list, &(&1 == "don't()")) do
      nil ->
        list |> Enum.reject(fn v -> v == "do()" end)

      _ ->
        i = Enum.find_index(list, &(&1 == "don't()"))
        j = Enum.find_index(Enum.drop(list, i + 1), &(&1 == "do()")) + i

        result_list =
          Enum.with_index(list)
          |> Enum.reject(fn {_value, index} ->
            index >= i && index <= j
          end)
          |> Enum.map(fn {v, _index} -> v end)

        remove_donts(result_list)
    end
  end

  def run do
    reg = ~r/(?:mul\([\d]{1,3},[\d]{1,3}\))|(?:do\(\))|(?:don\'t\(\))/

    input =
      File.read!("inputs/day-3.txt")
      |> (&Regex.scan(reg, &1)).()
      |> Enum.map(fn match -> hd(match) end)

    values =
      Enum.map(
        remove_donts(input),
        fn inst ->
          tuple =
            String.trim_leading(inst, "mul(")
            |> String.trim_trailing(")")
            |> String.split(",")
            |> Enum.map(fn v -> String.to_integer(v) end)

          tuple
        end
      )

    result = Enum.reduce(values, 0, fn [a, b], acc -> acc + a * b end)

    IO.puts("Result - Part 2: #{result}")
  end
end

Day3.run()
Day3Part2.run()
