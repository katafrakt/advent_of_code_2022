defmodule Signals do
  def init(length) do
    %{pos: 1, chars: :queue.new(), length: length}
  end

  def process(string, length) when is_integer(length), do: process(string, init(length))
  def process([char | rest], %{pos: pos, chars: chars, length: lgth}) do
    chars = if :queue.len(chars) >= lgth, do: :queue.out(chars) |> elem(1), else: chars
    chars = :queue.in(char, chars)

    charset =
      chars
      |> :queue.to_list()
      |> Enum.uniq()

    if length(charset) == lgth, do: pos, else: process(rest, %{pos: pos + 1, chars: chars, length: lgth})
  end
end

#"mjqjpqmgbljsphdztnvjfqwrcgsmlb"
File.read!("input")
|> String.to_charlist()
|> Signals.process(4)
|> IO.puts()

File.read!("input")
|> String.to_charlist()
|> Signals.process(14)
|> IO.puts()
