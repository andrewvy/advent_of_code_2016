defmodule AOC.Solutions.Day4 do
  defmodule Room do
    defstruct id: nil, name: "", checksum: "", valid?: false
  end

  @moduledoc """
  Solution for Day 4
  """

  def checksum_validator(%Room{name: name, checksum: checksum} = room) do
    computed_checksum =
      name
      |> String.replace("-", "")
      |> String.graphemes()
      |> Enum.reduce(%{}, fn(letter, acc) ->
        Map.update(acc, letter, 1, &(&1 + 1))
      end)
      |> Map.to_list()
      |> Enum.sort_by(fn({letter, value}) -> value end, &>=/2)
      |> Enum.take(5)
      |> Enum.map_join(fn({letter, value}) ->
        letter
      end)

    %Room{room | valid?: computed_checksum == checksum}
  end

  def solve(input, func \\ &count_room_ids/1) when is_binary(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&to_room/1)
    |> Enum.map(&checksum_validator/1)
    |> Enum.filter(&is_valid?/1)
    |> func.()
  end

  def count_room_ids(rooms) do
    rooms
    |> Enum.reduce(0, fn(room, acc) ->
      acc + room.id
    end)
  end

  def get_storeroom(rooms) do
    rooms
    |> Enum.map(&decrypt_room/1)
    |> Enum.find(fn(room) -> room.name =~ "northpole" end)
  end

  def decrypt_room(room), do: %Room{room | name: transform_input(room.name, room.id)}

  defp transform_input("", _), do: ""
  defp transform_input("-" <> tail, rot), do: " " <> transform_input(tail, rot)
  defp transform_input(<<character :: utf8, tail :: binary>>, rot) do
    rotated_character = caeser(character, rot)
    <<rotated_character :: utf8>> <> transform_input(tail, rot)
  end

  defp caeser(character, 0), do: character
  defp caeser(character, rot) when rot > 25, do: caeser(character, rem(rot, 26))
  defp caeser(character, rot) do
    case character + rot do
      result when result <= ?z -> result
      rotate -> rotate - ?z - 1 + ?a
    end
  end

  def to_room(input) do
    captures =
      ~r/(?<name>[a-z].+)-(?<id>\d+)\[(?<checksum>[a-z]+)\]/
      |> Regex.named_captures(input)

    %Room{id: String.to_integer(captures["id"]), name: captures["name"], checksum: captures["checksum"]}
  end

  def is_valid?(%Room{valid?: valid}), do: valid
end
