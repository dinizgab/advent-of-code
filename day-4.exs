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

    coordenates_map =
      for letter <- ["X", "M", "A", "S"],
          into: %{},
          do: {letter, get_coordenates(input, letter)}

    is_valid_path?(coordenates_map, "XMAS") |> IO.inspect()

    # Start from X
    # Check, for each X, if the coordenates around are M,
    # if so, check if the coordenates around the M are A,
    # if so, check if the coordenates around the A are S
    # If so, we have a valid path (+1)
  end
end

defmodule Day4Part2 do
  def is_valid_x_mas?(coordenate_map) do
    Enum.reduce(coordenate_map["A"], 0, fn coodernate, acc ->
      acc +
        check_x_coordenate(coordenate_map, coodernate)
    end)
  end

  def check_x_coordenate(coordenate_map, {x, y}) do
    if(
      # M on bottom
      # M on top
      # M on right
      # M on left
      (coordenate_map["M"] |> Enum.member?({x + 1, y - 1}) &&
         coordenate_map["M"] |> Enum.member?({x + 1, y + 1}) &&
         coordenate_map["S"] |> Enum.member?({x - 1, y + 1}) &&
         coordenate_map["S"] |> Enum.member?({x - 1, y - 1})) ||
        (coordenate_map["M"] |> Enum.member?({x - 1, y - 1}) &&
           coordenate_map["M"] |> Enum.member?({x - 1, y + 1}) &&
           coordenate_map["S"] |> Enum.member?({x + 1, y + 1}) &&
           coordenate_map["S"] |> Enum.member?({x + 1, y - 1})) ||
        (coordenate_map["M"] |> Enum.member?({x - 1, y + 1}) &&
           coordenate_map["M"] |> Enum.member?({x + 1, y + 1}) &&
           coordenate_map["S"] |> Enum.member?({x - 1, y - 1}) &&
           coordenate_map["S"] |> Enum.member?({x + 1, y - 1})) ||
        (coordenate_map["M"] |> Enum.member?({x - 1, y - 1}) &&
           coordenate_map["M"] |> Enum.member?({x + 1, y - 1}) &&
           coordenate_map["S"] |> Enum.member?({x - 1, y + 1}) &&
           coordenate_map["S"] |> Enum.member?({x + 1, y + 1}))
    ) do
      1
    else
      0
    end
  end

  def run do
    input =
      File.stream!("inputs/day-4.txt")
      |> Enum.map(&String.graphemes(&1))

    # [
    #  [".", "M", ".", "S", ".", ".", ".", ".", ".", "."],
    #  [".", ".", "A", ".", ".", "M", "S", "M", "S", "."],
    #  [".", "M", ".", "S", ".", "M", "A", "A", ".", "."],
    #  [".", ".", "A", ".", "A", "S", "M", "S", "M", "."],
    #  [".", "M", ".", "S", ".", "M", ".", ".", ".", "."],
    #  [".", ".", ".", ".", ".", ".", ".", ".", ".", "."],
    #  ["S", ".", "S", ".", "S", ".", "S", ".", "S", "."],
    #  [".", "A", ".", "A", ".", "A", ".", "A", ".", "."],
    #  ["M", ".", "M", ".", "M", ".", "M", ".", "M", "."],
    #  [".", ".", ".", ".", ".", ".", ".", ".", ".", "."]
    # ]

    coordenates_map =
      for letter <- ["M", "A", "S"],
          into: %{},
          do: {letter, Day4.get_coordenates(input, letter)}

    # Start from letter A's, which will be at index (x, y);
    # Check if the list of indexes [(x + 1, y - 1), (x + 1, y + 1), (x - 1, y + 1), (x - 1, y - 1)]
    # Contains exactly 2 M's and 2 S's and if they are in the same side (just need to check for one of them)
    # are_in_same_side =
    #  (x + 1, y - 1) == (x + 1, y + 1) || -> Both on right
    #  (x + 1, y + 1) == (x - 1, y + 1) || -> Both on bottom
    #  (x - 1, y + 1) == (x - 1, y - 1) || -> Both on left
    #  (x + 1, y - 1) == (x - 1, y + 1)    -> Both on top
    IO.puts(is_valid_x_mas?(coordenates_map))
  end
end

# Day4.run()
Day4Part2.run()
