defmodule Day6 do
  def calculate_path(map, {x, y}) do
    curr_direction = Enum.at(map, x) |> Enum.at(y)
    # Front coordinate
    {front_x, front_y} = get_next_step({x, y}, curr_direction)

    if(
      front_x >= length(map) || front_x < 0 ||
        front_y >= length(Enum.at(map, 0)) || front_y < 0
    ) do
      map
    else
      {curr_direction, front_x, front_y} =
        if Enum.at(Enum.at(map, front_x), front_y) == "#" do
          # If found a wall in the path, change direction to the right
          curr_direction = change_direction(curr_direction)
          {front_x, front_y} = get_next_step({x, y}, curr_direction)

          {curr_direction, front_x, front_y}
        else
          {curr_direction, front_x, front_y}
        end

      updated_map =
        List.update_at(map, x, fn row ->
          List.update_at(row, y, fn _ -> "X" end)
        end)

      updated_map =
        List.update_at(updated_map, front_x, fn row ->
          List.update_at(row, front_y, fn _ -> curr_direction end)
        end)

      calculate_path(updated_map, {front_x, front_y})
    end
  end

  def change_direction(curr_direction) do
    case curr_direction do
      "^" -> ">"
      ">" -> "v"
      "v" -> "<"
      "<" -> "^"
    end
  end

  def get_next_step({x, y}, curr_direction) do
    case curr_direction do
      "^" -> {x - 1, y}
      ">" -> {x, y + 1}
      "<" -> {x, y - 1}
      "v" -> {x + 1, y}
    end
  end

  def run do
    input =
      File.stream!("inputs/day-6.txt")
      |> Enum.map(&String.graphemes(&1))

    start_coordenates =
      hd(
        for {row, i} <- Enum.with_index(input),
            {col, j} <- Enum.with_index(row),
            col == "^",
            do: {i, j}
      )

    guard_path = calculate_path(input, start_coordenates)

    total_path =
      List.flatten(guard_path)
      |> Enum.count(fn tile -> tile == "X" end)

    IO.inspect(total_path + 1)
  end
end

Day6.run()
