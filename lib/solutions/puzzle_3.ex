defmodule AOC.Solutions.Puzzle3 do
  @moduledoc """
  This is the solution for Puzzle 3.

  This abuses Maps!
  """

  @up %{
    {0, 0} => {0, 0}, {1, 0} => {1, 0}, {2, 0} => {2, 0},
    {0, 1} => {0, 0}, {1, 1} => {1, 0}, {2, 1} => {2, 0},
    {0, 2} => {0, 1}, {1, 2} => {1, 1}, {2, 2} => {2, 1}
  }

  @down %{
    {0, 0} => {0, 1}, {1, 0} => {1, 1}, {2, 0} => {2, 1},
    {0, 1} => {0, 2}, {1, 1} => {1, 2}, {2, 1} => {2, 2},
    {0, 2} => {0, 2}, {1, 2} => {1, 2}, {2, 2} => {2, 2}
  }

  @left %{
    {0, 0} => {0, 0}, {1, 0} => {0, 0}, {2, 0} => {1, 0},
    {0, 1} => {0, 1}, {1, 1} => {0, 1}, {2, 1} => {1, 1},
    {0, 2} => {0, 2}, {1, 2} => {0, 2}, {2, 2} => {1, 2}
  }

  @right %{
    {0, 0} => {1, 0}, {1, 0} => {2, 0}, {2, 0} => {2, 0},
    {0, 1} => {1, 0}, {1, 1} => {2, 1}, {2, 1} => {2, 1},
    {0, 2} => {1, 1}, {1, 2} => {2, 2}, {2, 2} => {2, 2}
  }

  def normal_keypad do
    %{
      {0, 0} => 1, {1, 0} => 2, {2, 0} => 3,
      {0, 1} => 4, {1, 1} => 5, {2, 1} => 6,
      {0, 2} => 7, {1, 2} => 8, {2, 2} => 9
    }
  end

  def solve(input, keypad \\ normal_keypad()) do
    input
    |> translate_instructions()
    |> perform_instructions({1, 1}, keypad, [])
  end

  def translate_instructions(input), do:
    translate_instructions(input, [])
  def translate_instructions("", instructions), do:
    instructions |> Enum.reverse
  def translate_instructions("\n" <> rest_of_input, instructions), do:
    translate_instructions(rest_of_input, [:new_line | instructions])
  def translate_instructions("U" <> rest_of_input, instructions), do:
    translate_instructions(rest_of_input, [:up | instructions])
  def translate_instructions("D" <> rest_of_input, instructions), do:
    translate_instructions(rest_of_input, [:down | instructions])
  def translate_instructions("L" <> rest_of_input, instructions), do:
    translate_instructions(rest_of_input, [:left | instructions])
  def translate_instructions("R" <> rest_of_input, instructions), do:
    translate_instructions(rest_of_input, [:right | instructions])

  def perform_instructions(instructions, coords), do:
    perform_instructions(instructions, coords, normal_keypad(), [])
  def perform_instructions([], _coords, _keypad, codes), do:
    codes |> Enum.reverse()
  def perform_instructions([:new_line | instructions], {x, y}, keypad, codes), do:
    perform_instructions(instructions, {x, y}, keypad, [Map.get(keypad, {x, y})| codes])
  def perform_instructions([:up | instructions], {x, y}, keypad, codes), do:
    perform_instructions(instructions, Map.get(@up, {x, y}), keypad, codes)
  def perform_instructions([:down | instructions], {x, y}, keypad, codes), do:
    perform_instructions(instructions, Map.get(@down, {x, y}), keypad, codes)
  def perform_instructions([:left | instructions], {x, y}, keypad, codes), do:
    perform_instructions(instructions, Map.get(@left, {x, y}), keypad, codes)
  def perform_instructions([:right | instructions], {x, y}, keypad, codes), do:
    perform_instructions(instructions, Map.get(@right, {x, y}), keypad, codes)
end
