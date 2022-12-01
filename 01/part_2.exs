File.stream!("input")
|> Enum.reduce(%{by_elf: [], current: 0}, fn line, acc ->
  case line do
    "\n" ->
      %{by_elf: [acc.current | acc.by_elf], current: 0}
    _ ->
      {num, _} = Integer.parse(line)
      %{acc | current: acc.current + num}
    end
end)
|> Map.get(:by_elf)
|> Enum.sort()
|> Enum.reverse()
|> Enum.take(3)
|> Enum.sum()
|> IO.puts
