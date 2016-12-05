defmodule AOC.Solutions.Day5Test do
  alias AOC.Solutions.Day5

  use ExUnit.Case, async: true

  @moduletag timeout: 120000
  @input "reyedfim"

  test "Can solve part 1" do
    assert "f97c354d" == Day5.solve(@input)
  end
end
