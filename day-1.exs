defmodule Day1 do
  def read_file(input) do
    File.read!(input)
  end

  def separate_lists([], _i) do
    :done
  end

  def separate_lists(list) do
    list1 =
      Enum.filter(Enum.with_index(list), fn {_v, i} -> rem(i, 2) == 0 end)

    list2 =
      Enum.filter(Enum.with_index(list), fn {_v, i} -> rem(i, 2) != 0 end)

    %{list1: Enum.map(list1, fn ({v, _i}) -> elem(Integer.parse(v), 0) end), list2: Enum.map(list2, fn {v, _i} -> elem(Integer.parse(v), 0) end)}
  end

  def calculate_distances([], []) do
    0
  end

  def calculate_distances(list1, list2) do
    min1 = Enum.min(list1)
    min2 = Enum.min(list2)

    updated_list1 = List.delete(list1, min1)
    updated_list2 = List.delete(list2, min2)

    abs(min1 - min2) + calculate_distances(updated_list1, updated_list2)
  end

  def run do
    filepath = "inputs/day-1.txt"
    file = read_file(filepath)

    splitted_input = Enum.filter(String.split(file, [" ", "\n"]), fn x -> x != "" end)
    separated_lists = separate_lists(splitted_input)

    total_distance = calculate_distances(separated_lists[:list1], separated_lists[:list2])
    IO.puts("Part 1 result: #{total_distance}")
  end
end

defmodule Day1Part2 do
  def similarity([], _) do
    0
  end

  def similarity([head | tail], list2) do
    total_occurrences = Enum.reduce(list2, 0, fn x, acc ->
      if x == head do
        acc = acc + 1
      else 
        acc
      end
    end)

    (head * total_occurrences) + similarity(tail, list2)
  end

  def run do
    filepath = "inputs/day-1.txt"
    file = Day1.read_file(filepath)

    splitted_input = Enum.filter(String.split(file, [" ", "\n"]), fn x -> x != "" end)
    separated_lists = Day1.separate_lists(splitted_input)

    total_similarity =  similarity(separated_lists[:list1], separated_lists[:list2])
    IO.puts("Part 2 result: #{total_similarity}")
  end
end

Day1.run()
Day1Part2.run()
