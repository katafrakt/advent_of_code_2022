File.stream!("input")
|> Enum.reduce(%{max: 0, current: 0}, fn line, acc ->
  case line do
    "\n" ->
      max = if acc.current > acc.max, do: acc.current, else: acc.max
      %{max: max, current: 0}
    _ ->
      {num, _} = Integer.parse(line)
      %{acc | current: acc.current + num}
    end
end)
|> Map.get(:max)
|> IO.puts
