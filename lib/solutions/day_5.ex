defmodule HashPrinter do
  @moduledoc """
  HashPrinter display, courtesy of code from @orestis. Wanted to have
  something quick to display the current password!
  """

  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, [])
  end

  def init(_) do
    Process.send_after(self(), :tick, 0)
    {:ok, {0, %{}}}
  end

  def add_character(pid, character) do
    pid |> GenServer.cast({:add_character, character})
  end

  def stop(pid) do
    pid |> GenServer.cast(:stop)
  end

  def handle_info(:tick, {_, new_map} = state) do
    print(new_map)
    Process.send_after(self(), :tick, 50)
    {:noreply, state}
  end

  def handle_cast(:stop, _) do
    IO.write IO.ANSI.reset()
    {:stop, :normal, :ok}
  end

  def handle_cast({:add_character, character}, {current_index, map}) do
    new_index = current_index + 1
    new_map = Map.put(map, current_index + 1, character)
    {:noreply, {new_index, new_map}}
  end

  defp print(map) do
    r = 32..126
    l = for i <- 1..8, do: Map.get(map, i, nil)
    l = Enum.map(l, fn
      (nil) -> [IO.ANSI.normal(), IO.ANSI.faint(), Enum.random(r)]
      (c) -> [IO.ANSI.normal(), IO.ANSI.bright(), IO.ANSI.primary_font(), c]
    end)

    IO.write  <<27, "[", "?25l">> #  CSI ?25l
    IO.write IO.ANSI.clear_line()
    IO.write [IO.ANSI.reverse(),  l]
    IO.write '\r'
  end
end

defmodule AOC.Solutions.Day5 do
  def solve(input) do
    {:ok, hash_printer_pid} = HashPrinter.start_link()

    password =
      Stream.iterate(0, &(&1 + 1))
      |> Stream.map(&(hash(input, &1)))
      |> Stream.flat_map(&get_character/1)
      |> Stream.map(&(send_to_printer(hash_printer_pid, &1)))
      |> Stream.take(8)
      |> Enum.to_list
      |> Enum.join()

    hash_printer_pid |> HashPrinter.stop()

    password
  end

  defp hash(input, integer) do
    :crypto.hash(:md5, [input, Integer.to_string(integer)])
  end

  defp get_character(<<0 :: integer-size(20), char :: integer-size(4), _rest :: bitstring>>) do
    "0"<> character = Base.encode16(<<0::integer-size(4), char::integer-size(4)>>, case: :lower)
    [character]
  end
  defp get_character(_), do: []

  defp send_to_printer(pid, character) do
    pid |> HashPrinter.add_character(character)
    character
  end
end
