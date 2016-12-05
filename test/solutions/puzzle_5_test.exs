defmodule AOC.Solutions.Puzzle5Test do
  alias AOC.Solutions.Puzzle5

  use ExUnit.Case, async: true

  @input_file "./test/data/day_3.txt"

  test "Can solve puzzle" do
    {:ok, input} =
      @input_file
      |> File.read()

    assert 869 == Puzzle5.solve(input)
  end
end
