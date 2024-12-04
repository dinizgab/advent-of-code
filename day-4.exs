defmodule Day4 do
  def get_coordenates(input, value) do
    for {row, i} <- Enum.with_index(input),
        {cell, j} <- Enum.with_index(row),
        cell == value,
        do: {i, j}
  end

  def is_valid_path?(coordenate_map, word) do
    first_letter = String.first(word)
    starting_coordenates = coordenate_map[first_letter]
    letters = String.graphemes(word)

    Enum.reduce(starting_coordenates, 0, fn coordenate, acc ->
      # Horizontal
      # Vertical
      # Diagonal (right)
      # Diagonal (left) - backwards words
      acc +
        check_path(coordenate_map, letters, coordenate, 0, 1) +
        check_path(coordenate_map, letters, coordenate, 0, -1) +
        check_path(coordenate_map, letters, coordenate, 1, 0) +
        check_path(coordenate_map, letters, coordenate, -1, 0) +
        check_path(coordenate_map, letters, coordenate, 1, -1) +
        check_path(coordenate_map, letters, coordenate, 1, 1) +
        check_path(coordenate_map, letters, coordenate, -1, -1) +
        check_path(coordenate_map, letters, coordenate, -1, 1)
    end)
  end

  def check_path(_, [], _, _, _) do
    1
  end

  def check_path(coordenate_map, [current | rest], {x, y}, x_direction, y_direction) do
    IO.inspect(current)

    if coordenate_map[current] |> Enum.member?({x, y}) do
      check_path(
        coordenate_map,
        rest,
        {x + x_direction, y + y_direction},
        x_direction,
        y_direction
      )
    else
      0
    end
  end

  def run do
    input =
      File.stream!("inputs/day-4.txt")
      |> Enum.map(&String.graphemes(&1))

    IO.inspect(input)

    # [
    #  [".", "S", "A", "M", "X", "X", "M", "A", "S", "."],
    #  [".", "S", "A", "M", "X", "M", "S", ".", ".", "."],
    #  [".", ".", ".", "S", ".", ".", "A", ".", ".", "."],
    #  [".", ".", "A", ".", "A", ".", "M", "S", ".", "X"],
    #  ["X", "M", "A", "S", "A", "M", "X", ".", "M", "M"],
    #  ["X", ".", ".", ".", ".", ".", "X", "A", ".", "A"],
    #  ["S", ".", "S", ".", "S", ".", "S", ".", "S", "S"],
    #  [".", "A", ".", "A", ".", "A", ".", "A", ".", "A"],
    #  [".", ".", "M", ".", "M", ".", "M", ".", "M", "M"],
    #  [".", "X", ".", "X", ".", "X", "M", "A", "S", "X"]
    # ]

    coordenate_map =
      for letter <- ["X", "M", "A", "S"], into: %{}, do: {letter, get_coordenates(input, letter)}

    is_valid_path?(coordenate_map, "XMAS") |> IO.inspect()

    # Start from X
    # Check, for each X, if the coordenates around are M,
    # if so, check if the coordenates around the M are A,
    # if so, check if the coordenates around the A are S
    # If so, we have a valid path (+1)
  end
end

Day4.run()
