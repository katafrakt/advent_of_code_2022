defmodule Machine do
  def init do
    %{cycle: 0, x: 1, interesting: []}
  end

  def process_op(state, "noop") do
    state
    |> add_cycle()
    |> check_cycle()
  end

  def process_op(state, "addx", num) do
    state
    |> process_op("noop")
    |> add_cycle()
    |> check_cycle()
    |> add_x(num)
  end

  def sum_interesting(state), do: Enum.sum(state.interesting)

  defp add_cycle(state), do: %{state | cycle: state.cycle + 1}
  defp add_x(state, num), do: %{state | x: state.x + String.to_integer(num)}
  defp check_cycle(state) do
    if Integer.mod(state.cycle, 40) == 1, do: IO.write("\n")
    if abs(Integer.mod(state.cycle, 40) - 1 - state.x) <= 1, do: IO.write("#"), else: IO.write(".")

    if Integer.mod(state.cycle - 20, 40) == 0 do
      %{state | interesting: [state.cycle * state.x | state.interesting]}
    else
      state
    end
  end
end

File.stream!("input")
|> Enum.reduce(Machine.init(), fn line, acc ->
  split =
    line
    |> String.trim()
    |> String.split(" ")

  case split do
    ["noop"] -> Machine.process_op(acc, "noop")
    [instr, val] -> Machine.process_op(acc, instr, val)
  end
end)
|> tap(fn _ -> IO.puts("") end)
|> Machine.sum_interesting()
|> IO.puts()
