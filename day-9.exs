defmodule Day9 do
  def swap(disk, curr_index, last_index) do
    e1 = Enum.at(disk, curr_index)
    e2 = Enum.at(disk, last_index)

    disk
    |> List.replace_at(curr_index, e2)
    |> List.replace_at(last_index, e1)
  end

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

          last_valid_element = Enum.at(tail, last_valid_index)
          IO.inspect(last_valid_element)
          {_, popped_list} = List.pop_at(tail, -1)

          [last_valid_element] ++ format_disk(popped_list) ++ [head]
        else
          [head] ++ format_disk(tail)
        end
    end
  end

  def run do
    input = "2333133121414131402"

    disk_value =
      String.graphemes(input)
      |> Enum.with_index()
      |> Enum.reduce("", fn {v, i}, acc ->
        if rem(i, 2) == 0 do
          acc <> String.duplicate(Integer.to_string(div(i, 2)), elem(Integer.parse(v), 0))
        else
          acc <> String.duplicate(".", elem(Integer.parse(v), 0))
        end
      end)

    IO.inspect(disk_value)

    # Search for first valid index from left to right
    # Search for first valid index from right to left
    # Swap them
    formated_disk_value =
      String.graphemes(disk_value)
      |> format_disk()

    IO.inspect(formated_disk_value)
  end
end

Day9.run()
