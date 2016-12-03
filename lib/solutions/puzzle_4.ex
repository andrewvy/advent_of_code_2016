defmodule AOC.Solutions.Puzzle4 do
  @moduledoc """
  This is the solution for Puzzle4.

  This abuses Maps!
  """

  def normal_keypad do
    %{
      {0, 0} => 1, {1, 0} => 2, {2, 0} => 3,
      {0, 1} => 4, {1, 1} => 5, {2, 1} => 6,
      {0, 2} => 7, {1, 2} => 8, {2, 2} => 9,

      :up => %{
        {0, 0} => {0, 0}, {1, 0} => {1, 0}, {2, 0} => {2, 0},
        {0, 1} => {0, 0}, {1, 1} => {1, 0}, {2, 1} => {2, 0},
        {0, 2} => {0, 1}, {1, 2} => {1, 1}, {2, 2} => {2, 1}
      },

      :down => %{
        {0, 0} => {0, 1}, {1, 0} => {1, 1}, {2, 0} => {2, 1},
        {0, 1} => {0, 2}, {1, 1} => {1, 2}, {2, 1} => {2, 2},
        {0, 2} => {0, 2}, {1, 2} => {1, 2}, {2, 2} => {2, 2}
      },

      :left => %{
        {0, 0} => {0, 0}, {1, 0} => {0, 0}, {2, 0} => {1, 0},
        {0, 1} => {0, 1}, {1, 1} => {0, 1}, {2, 1} => {1, 1},
        {0, 2} => {0, 2}, {1, 2} => {0, 2}, {2, 2} => {1, 2}
      },

      :right => %{
        {0, 0} => {1, 0}, {1, 0} => {2, 0}, {2, 0} => {2, 0},
        {0, 1} => {1, 0}, {1, 1} => {2, 1}, {2, 1} => {2, 1},
        {0, 2} => {1, 1}, {1, 2} => {2, 2}, {2, 2} => {2, 2}
      }
    }
  end

  def star_keypad do
    %{
                                {2, 0} => 1,
                   {1, 1} => 2, {2, 1} => 3, {3, 1} => 4,
      {0, 2} => 5, {1, 2} => 6, {2, 2} => 7, {3, 2} => 8, {4, 2} => 9,
                 {1, 3} => "A", {2, 3} => "B", {3, 3} => "C",
                                {2, 4} => "D",

      :up => %{
                                          {2, 0} => {2, 0},
                        {1, 1} => {1, 1}, {2, 1} => {2, 0}, {3, 1} => {3, 1},
      {0, 2} => {0, 2}, {1, 2} => {1, 1}, {2, 2} => {2, 1}, {3, 2} => {3, 1}, {4, 2} => {4, 2},
                        {1, 3} => {1, 2}, {2, 3} => {2, 2}, {3, 3} => {3, 2},
                                          {2, 4} => {2, 3},
      },

      :down => %{
                                          {2, 0} => {2, 1},
                        {1, 1} => {1, 2}, {2, 1} => {2, 2}, {3, 1} => {3, 2},
      {0, 2} => {0, 2}, {1, 2} => {1, 3}, {2, 2} => {2, 3}, {3, 2} => {3, 3}, {4, 2} => {4, 2},
                        {1, 3} => {1, 3}, {2, 3} => {2, 4}, {3, 3} => {3, 3},
                                          {2, 4} => {2, 4},
      },

      :left => %{
                                          {2, 0} => {2, 0},
                        {1, 1} => {1, 1}, {2, 1} => {1, 1}, {3, 1} => {2, 1},
      {0, 2} => {0, 2}, {1, 2} => {0, 2}, {2, 2} => {1, 2}, {3, 2} => {2, 2}, {4, 2} => {3, 2},
                        {1, 3} => {1, 3}, {2, 3} => {1, 3}, {3, 3} => {2, 3},
                                          {2, 4} => {2, 4},
      },

      :right => %{
                                          {2, 0} => {2, 0},
                        {1, 1} => {2, 1}, {2, 1} => {3, 1}, {3, 1} => {3, 1},
      {0, 2} => {1, 2}, {1, 2} => {2, 2}, {2, 2} => {3, 2}, {3, 2} => {4, 2}, {4, 2} => {4, 2},
                        {1, 3} => {2, 3}, {2, 3} => {3, 3}, {3, 3} => {3, 3},
                                          {2, 4} => {2, 4},
      }
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
  def perform_instructions([:new_line | instructions], coords, keypad, codes), do:
    perform_instructions(instructions, coords, keypad, [keypad[coords]| codes])
  def perform_instructions([instruction | instructions], coords, keypad, codes) when instruction in [:up, :down, :left, :right], do:
    perform_instructions(instructions, keypad[instruction][coords], keypad, codes)
end
