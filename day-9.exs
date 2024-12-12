defmodule Day9 do
  def format_disk(disk) do
    case disk do
      [] ->
        []

      [x] ->
        [x]

      _ ->
        head = hd(disk)
        tail = tl(disk)

        if head == "." do
          last_valid_index =
            disk
            |> Enum.reverse()
            |> Enum.find_index(fn v -> v != "." end)

          if last_valid_index == nil do
            [head] ++ format_disk(tail)
          else
            index_offset = length(tail) - last_valid_index - 1
            last_valid_element = Enum.at(tail, index_offset)
            {_, popped_list} = List.pop_at(tail, index_offset)

            [last_valid_element] ++ format_disk(popped_list) ++ [head]
          end
        else
          [head] ++ format_disk(tail)
        end
    end
  end

  def run do
    input =
      File.read!("inputs/day-9.txt")
      |> String.graphemes()

    disk_value =
      input
      |> List.delete_at(length(input) - 1)
      |> Enum.with_index()
      |> Enum.reduce([], fn {v, i}, acc ->
        if rem(i, 2) == 0 do
          acc ++ [String.duplicate(Integer.to_string(div(i, 2)), elem(Integer.parse(v), 0))]
        else
          acc ++ [String.duplicate(".", elem(Integer.parse(v), 0))]
        end
      end)

    IO.inspect(disk_value, limit: :infinity)

    # Search for first valid index from left to right
    # Search for first valid index from right to left
    # Swap them
    # Problem lies here, i can't send String.graphemes, because it splits the string into individual characters
    checksum_value =
       format_disk()
      |> Enum.with_index()
      |> Enum.reduce(0, fn {v, i}, acc ->
        if v != "." do
          acc + elem(Integer.parse(v), 0) * i
        else
          acc
        end
      end)

    IO.inspect(checksum_value)
  end
end

Day9.run()
