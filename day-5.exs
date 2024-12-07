defmodule Day5 do
  def run do
    input = File.read!("inputs/day-5.txt")

    {rules, [_ | lists]} = String.split(input, "\n") |> Enum.split_while(&(&1 != ""))

    grouped =
      rules
      |> Enum.map(&String.split(&1, "|"))
      |> Enum.group_by(fn [left, _right] -> left end, fn [_left, right] -> right end)

    valid_lists =
      lists
      |> List.delete_at(length(lists) - 1)
      |> Enum.map(&String.split(&1, ","))
      |> Enum.filter(fn list ->
        Enum.all?(list, fn x ->
          index = Enum.find_index(list, &(&1 == x))
          rest = Enum.slice(list, (index + 1)..length(list))
          begin = if index == 0, do: [], else: Enum.slice(list, 0..(index - 1))

          valid_previous? =
            Enum.all?(begin, fn y ->
              rule = if grouped[y] == nil, do: [], else: grouped[y]
              x in rule
            end)

          valid_next? =
            Enum.all?(
              rest,
              fn x ->
                grouped[x] == nil || (&(&1 in grouped[x]))
              end
            )

          valid_next? && valid_previous?
        end)
      end)

    IO.puts(
      "Result - Part 1:
      #{Enum.reduce(valid_lists, 0, fn list, acc ->
        number = Integer.parse(Enum.at(list, div(length(list), 2)))

        acc + (number |> elem(0))
      end)}"
    )
  end
end

Day5.run()
