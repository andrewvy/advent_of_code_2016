defmodule AOC.Solutions.Day4Test do
  alias AOC.Solutions.Day4
  alias AOC.Solutions.Day4.Room

  use ExUnit.Case, async: true

  @input_file "./test/data/day_4.txt"

  test "Can convert line input into Room struct" do
    room =
      "hqcfqwydw-fbqijys-whqii-huiuqhsx-660[qhiwf]"
      |> Day4.to_room()

    assert %Room{name: "hqcfqwydw-fbqijys-whqii-huiuqhsx", checksum: "qhiwf", id: 660} == room
  end

  test "Can verify checksum via letter counting" do
    room =
      "hqcfqwydw-fbqijys-whqii-huiuqhsx-660[qhiwf]"
      |> Day4.to_room()
      |> Day4.checksum_validator()

    assert room.valid? == true
  end

  test "Can solve Part 1" do
    {:ok, input} =
      @input_file
      |> File.read()

    assert 245102 == Day4.solve(input)
  end

  test "Can solve Part 2" do
    {:ok, input} =
      @input_file
      |> File.read()

    assert %Room{name: "northpole object storage", checksum: "chsfb", id: 324, valid?: true} == Day4.solve(input, &Day4.get_storeroom/1)
  end
end
