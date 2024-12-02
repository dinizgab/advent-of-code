defmodule Day2 do
  def ascending([]) do
    true
  end

  def ascending([_]) do
    true
  end

  def ascending([head | tail]) when head > hd(tail), do: false

  def ascending([_ | tail]) do
    ascending(tail)
  end

  def descending([]) do
    true
  end

  def descending([_]) do
    true
  end

  def descending([head | tail]) when head < hd(tail), do: false

  def descending([_ | tail]) do
    descending(tail)
  end

  def calculate_distance([]) do
    true
  end

  def calculate_distance([_]) do
    true
  end

  def calculate_distance([head | tail]) do
    abs(head - hd(tail)) >= 1 && abs(head - hd(tail)) <= 3 && calculate_distance(tail)
  end

  def run do
    input_path = "inputs/day-2.txt"

    input =
      File.stream!(input_path)
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.split(&1, " "))
      |> Enum.map(fn row -> Enum.map(row, &String.to_integer/1) end)

    # input = [
    #  [7, 6, 4, 2, 1],
    #  [1, 2, 7, 8, 9],
    #  [9, 7, 6, 2, 1],
    #  [1, 3, 2, 4, 5],
    #  [8, 6, 4, 4, 1],
    #  [1, 3, 6, 7, 9]
    # ]

    asc_and_desc_rows = Enum.filter(input, fn row -> ascending(row) || descending(row) end)
    least_distant_rows = Enum.filter(asc_and_desc_rows, fn row -> calculate_distance(row) end)
    total_rows = Enum.count(least_distant_rows)

    IO.inspect(asc_and_desc_rows)
    IO.inspect(least_distant_rows)
    IO.puts(total_rows)
  end
end

defmodule Day2Part2 do
  def ascending(list) do
    Enum.chunk_every(list, 2, 1, :discard)
    |> Enum.all?(fn [a, b] -> a < b end)
  end

  def descending(list) do
    Enum.chunk_every(list, 2, 1, :discard)
    |> Enum.all?(fn [a, b] -> a > b end)
  end

  def removedOne(list) do
    for x <- list, do: List.delete(list, x)
  end

  def run do
    input_path = "inputs/day-2.txt"

    input =
      File.stream!(input_path)
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.split(&1, " "))
      |> Enum.map(fn row -> Enum.map(row, &String.to_integer/1) end)

    IO.puts(ascending([1, 2, 3, 4, 5]))
    IO.puts(ascending([1, 2, 2, 4, 5]))
    IO.inspect(removedOne([1, 2, 3, 4, 5]))
    IO.puts(ascending([1]))
  end
end

Day2.run()
Day2Part2.run()
