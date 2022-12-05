defmodule Crates do
  def new_test do
    %{
      "1" => [:n, :z],
      "2" => [:d, :c, :m],
      "3" => [:p]
    }
  end

  def new do
    %{
      "1" => [:w, :l, :s],
      "2" => [:q, :n, :t, :j],
      "3" => [:j, :f, :h, :c, :s],
      "4" => [:b, :g, :n, :w, :m, :r, :t],
      "5" => [:b, :q, :h, :d, :s, :l, :r, :t],
      "6" => [:l, :r, :h, :f, :v, :b, :j, :m],
      "7" => [:m, :j, :n, :r, :w, :d],
      "8" => [:j, :d, :n, :h, :f, :t, :z, :b],
      "9" => [:t, :f, :b, :n, :q, :l, :h]
    }
  end

  def move(crates, from, to) do
    [crate | from_stack] = crates[from]
    to_stack = [crate | crates[to]]

    crates
    |> Map.put(from, from_stack)
    |> Map.put(to, to_stack)
  end

  def move_many(crates, _, _, 0), do: crates
  def move_many(crates, from, to, amount) do
    crates
    |> move(from, to)
    |> move_many(from, to, amount - 1)
  end

  def move_9001(crates, from, to, amount) do
    substack = Enum.take(crates[from], amount)
    from_stack = Enum.drop(crates[from], amount)
    to_stack = substack ++ crates[to]

    crates
    |> Map.put(from, from_stack)
    |> Map.put(to, to_stack)
  end

  def tops(crates) do
    Enum.map(crates, fn {_, [crate | _]} -> crate end)
  end
end

File.stream!("input")
|> Enum.reduce(Crates.new(), fn line, acc ->
  command = Regex.named_captures(~r/move (?<amount>\d+) from (?<from>\d+) to (?<to>\d+)/, line)
  amount = String.to_integer(command["amount"])
  Crates.move_many(acc, command["from"], command["to"], amount)
end)
|> Crates.tops()
|> Enum.map(&Atom.to_string/1)
|> Enum.join("")
|> String.upcase()
|> IO.puts()

File.stream!("input")
|> Enum.reduce(Crates.new(), fn line, acc ->
  command = Regex.named_captures(~r/move (?<amount>\d+) from (?<from>\d+) to (?<to>\d+)/, line)
  amount = String.to_integer(command["amount"])
  Crates.move_9001(acc, command["from"], command["to"], amount)
end)
|> Crates.tops()
|> Enum.map(&Atom.to_string/1)
|> Enum.join("")
|> String.upcase()
|> IO.puts()
