defmodule CleaningDuty do
  def sections_contain?(raw_input) do
    [[x1, x2], [y1, y2]] = process_input(raw_input)
    (x1 >= y1 && x2 <= y2) || (x1 <= y1 && x2 >= y2)
  end

  def sections_overlap?(raw_input) do
    [[x1, x2], [y1, y2]] = process_input(raw_input)
    !Range.disjoint?(Range.new(x1, x2), Range.new(y1, y2))
  end

  defp process_input(raw_input) do
    raw_input
      |> String.trim()
      |> String.split(",")
      |> Enum.map(fn x -> String.split(x, "-") |> Enum.map(&String.to_integer/1) end)
  end
end

File.stream!("input")
|> Enum.reduce(0, fn line, acc ->
  if CleaningDuty.sections_contain?(line), do: acc + 1, else: acc
end)
|> IO.puts

File.stream!("input")
|> Enum.reduce(0, fn line, acc ->
  if CleaningDuty.sections_overlap?(line), do: acc + 1, else: acc
end)
|> IO.puts
