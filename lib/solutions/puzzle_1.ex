defmodule AOC.Solutions.Puzzle1.Position do
  defstruct [
    current_direction: :north,
    x: 0,
    y: 0
  ]
end

defmodule AOC.Solutions.Puzzle1 do
  alias AOC.Solutions.Puzzle1.Position

  def solve(input) do
    input
    |> split_input()
    |> perform()
    |> calculate_distance_from_point({0, 0})
  end

  def calculate_distance_from_point(%Position{x: x, y: y}, {point_x, point_y}) do
    abs(x - point_x) + abs(y - point_y)
  end

  defp split_input(string), do: string |> String.split(", ")

  defp perform(list_of_instructions) when is_list(list_of_instructions) do
    list_of_instructions
    |> Enum.reduce(%Position{}, &perform/2)
  end

  defp perform("R" <> tiles, state), do: rotate(state, :r) |> move(String.to_integer(tiles))
  defp perform("L" <> tiles, state), do: rotate(state, :l) |> move(String.to_integer(tiles))

  defp rotate(%Position{current_direction: :north} = state, :r), do: %Position{state | current_direction: :east}
  defp rotate(%Position{current_direction: :north} = state, :l), do: %Position{state | current_direction: :west}

  defp rotate(%Position{current_direction: :east} = state, :r), do: %Position{state | current_direction: :south}
  defp rotate(%Position{current_direction: :east} = state, :l), do: %Position{state | current_direction: :north}

  defp rotate(%Position{current_direction: :south} = state, :r), do: %Position{state | current_direction: :west}
  defp rotate(%Position{current_direction: :south} = state, :l), do: %Position{state | current_direction: :east}

  defp rotate(%Position{current_direction: :west} = state, :r), do: %Position{state | current_direction: :north}
  defp rotate(%Position{current_direction: :west} = state, :l), do: %Position{state | current_direction: :south}

  defp move(%Position{current_direction: :north} = state, tiles), do: %Position{state | y: state.y + tiles}
  defp move(%Position{current_direction: :east} = state, tiles), do: %Position{state | x: state.x + tiles}
  defp move(%Position{current_direction: :south} = state, tiles), do: %Position{state | y: state.y - tiles}
  defp move(%Position{current_direction: :west} = state, tiles), do: %Position{state | x: state.x - tiles}
end
