defmodule Rucksacks do
  def find_duplicates(line) do
    half = String.length(line)/2 |> trunc()
    line
    |> String.split_at(half)
    |> then(fn {a, b} ->
      MapSet.intersection(to_set(a), to_set(b))
      |> MapSet.to_list()
    end)
  end

  defp to_set(string) when is_binary(string) do
    String.to_charlist(string)
    |> MapSet.new()
  end

  def priority(char) do
    if char >= 97, do: char - 96, else: char - 65 + 27
  end

  def find_badge(group) do
    group
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_charlist/1)
    |> Enum.map(&MapSet.new/1)
    |> Enum.reduce(&MapSet.intersection/2)
  end
end

File.stream!("input")
|> Enum.reduce([], fn line, acc ->
  acc ++ Rucksacks.find_duplicates(String.trim(line))
end)
|> Enum.map(&Rucksacks.priority/1)
|> Enum.sum()
|> IO.puts()

File.stream!("input")
|> Stream.chunk_every(3)
|> Stream.flat_map(&Rucksacks.find_badge/1)
|> Enum.map(&Rucksacks.priority/1)
|> Enum.sum()
|> IO.puts()
