defmodule AOC.Solutions.Puzzle6Test do
  alias AOC.Solutions.Puzzle6

  use ExUnit.Case, async: true

  @input_file "./test/data/day_3.txt"

  test "Can solve puzzle" do
    {:ok, input} =
      @input_file
      |> File.read()

    assert 1544 == Puzzle6.solve(input)
  end
end
