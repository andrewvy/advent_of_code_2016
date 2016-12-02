defmodule AOC.Solutions.Puzzle2.Position do
  @moduledoc """
  This struct contains fields for keeping track of the current direction,
  and the coordinates of the current position.
  """

  @type t :: %__MODULE__{
    current_direction: :north | :east | :south | :west,
    x: integer(),
    y: integer()
  }

  defstruct [
    current_direction: :north,
    visited: MapSet.new(),
    visited_history: [],
    x: 0,
    y: 0
  ]
end

defmodule AOC.Solutions.Puzzle2 do
  alias AOC.Solutions.Puzzle2.Position

  @moduledoc """
  This is the solution for Puzzle 2, which utilizes function head pattern matching to
  control how to change the position based on the rotation and the number of tiles moved.

  Compared to Puzzle 1's solution, this time we have to keep track of the intermediary tiles
  that the person has traversed over.

  I used a MapSet, which is a convenient Set datastructure to store all my positions.

  All positions are stored in the MapSet in tuple form of: {x, y}

  Then, it becomes a simple check to see if a tile has already been visited by checking if it
  exists in the `visited` MapSet.

  I keep track of all visited tiles, and also the history of all the times the person has traversed
  the same tile in a `visited_history` List.

  Lastly, to get the first tile the person has visited twice, you can check the `visited_history` List
  and get the last (first) entry of the list.
  """

  @spec solve(String.t) :: integer()
  def solve(input) do
    input
    |> split_input()
    |> perform()
    |> get_first_visited_twice()
    |> calculate_distance_from_point({0, 0})
  end

  @spec calculate_distance_from_point(Position.t | {integer(), integer()}, {integer(), integer()}) :: integer()
  def calculate_distance_from_point(%Position{x: x, y: y}, {point_x, point_y}) do
    calculate_distance_from_point({x, y}, {point_x, point_y})
  end
  def calculate_distance_from_point({x, y}, {point_x, point_y}) do
    abs(x - point_x) + abs(y - point_y)
  end

  @spec get_first_visited_twice(Position.t) :: {integer(), integer()}
  def get_first_visited_twice(%Position{visited_history: visited_history}) do
    List.last(visited_history)
  end

  # ---

  @spec split_input(String.t) :: String.t
  defp split_input(string), do: string |> String.split(", ")

  @spec perform([] | [String.t] | String.t) :: Position.t
  defp perform(list_of_instructions) when is_list(list_of_instructions) do
    list_of_instructions
    |> Enum.reduce(%Position{}, &perform/2)
  end
  defp perform("R" <> tiles, state), do: rotate(state, :r) |> move_multiple(String.to_integer(tiles))
  defp perform("L" <> tiles, state), do: rotate(state, :l) |> move_multiple(String.to_integer(tiles))

  @spec rotate(Position.t, :r | :l) :: Position.t
  defp rotate(%Position{current_direction: :north} = state, :r), do: %Position{state | current_direction: :east}
  defp rotate(%Position{current_direction: :north} = state, :l), do: %Position{state | current_direction: :west}
  defp rotate(%Position{current_direction: :east} = state, :r), do: %Position{state | current_direction: :south}
  defp rotate(%Position{current_direction: :east} = state, :l), do: %Position{state | current_direction: :north}
  defp rotate(%Position{current_direction: :south} = state, :r), do: %Position{state | current_direction: :west}
  defp rotate(%Position{current_direction: :south} = state, :l), do: %Position{state | current_direction: :east}
  defp rotate(%Position{current_direction: :west} = state, :r), do: %Position{state | current_direction: :north}
  defp rotate(%Position{current_direction: :west} = state, :l), do: %Position{state | current_direction: :south}

  @spec move_multiple(Position.t, integer()) :: Position.t
  defp move_multiple(state, tiles) do
    1..tiles
    |> Enum.reduce(state, fn(_, acc) ->
      acc
      |> move()
      |> check_if_visited_before()
      |> add_position_to_visited()
    end)
  end

  @spec move(Position.t) :: Position.t
  defp move(%Position{current_direction: :north} = state), do: %Position{state | y: state.y + 1}
  defp move(%Position{current_direction: :east} = state), do: %Position{state | x: state.x + 1}
  defp move(%Position{current_direction: :south} = state), do: %Position{state | y: state.y - 1}
  defp move(%Position{current_direction: :west} = state), do: %Position{state | x: state.x - 1}

  @spec add_position_to_visited(Position.t) :: Position.t
  defp add_position_to_visited(position) do
    %Position{position | visited: position.visited |> MapSet.put({position.x, position.y})}
  end

  @spec check_if_visited_before(Position.t) :: Position.t
  defp check_if_visited_before(position) do
    case MapSet.member?(position.visited, {position.x, position.y}) do
      true ->
        %Position{position | visited_history: [{position.x, position.y} | position.visited_history]}
      false ->
        position
    end
  end
end
