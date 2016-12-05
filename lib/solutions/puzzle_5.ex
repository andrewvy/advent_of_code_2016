defmodule AOC.Solutions.Puzzle5 do
  def solve(input) do
    input
    |> String.split("\n")
    |> Enum.flat_map(&String.split/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk(3)
    |> Enum.count(&is_triangle?/1)
  end

  defp is_triangle?([a, b, c]) when a + b > c and a + c > b and b + c > a, do: true
  defp is_triangle?([_, _, _]), do: false
end
