defmodule RockPaperScissors do
  def resolve_part_1(my, their) do
    their = case their do
      "A" -> :rock
      "B" -> :paper
      "C" -> :scissors
    end

    my = case my do
      "X" -> :rock
      "Y" -> :paper
      "Z" -> :scissors
    end

    resolve(my, their)
  end

  def resolve_part_2(my, their) do
    their = case their do
      "A" -> :rock
      "B" -> :paper
      "C" -> :scissors
    end

    my = case my do
      "X" -> lose_with(their)
      "Y" -> their
      "Z" -> win_with(their)
    end

    resolve(my, their)
  end

  defp resolve(my, their) do
    shape_points = case my do
      :rock -> 1
      :paper -> 2
      :scissors -> 3
    end

    result_points = cond do
      my == their -> 3
      won?(my, their) -> 6
      true -> 0
    end

    shape_points + result_points
  end

  # draws are not possible here already
  defp won?(my, their) do
    case {my, their} do
      {:rock, :scissors} -> true
      {:scissors, :paper} -> true
      {:paper, :rock} -> true
      _ -> false
    end
  end

  defp lose_with(:paper), do: :rock
  defp lose_with(:rock), do: :scissors
  defp lose_with(:scissors), do: :paper

  defp win_with(:paper), do: :scissors
  defp win_with(:rock), do: :paper
  defp win_with(:scissors), do: :rock
end

input = File.stream!("input")

input
|> Enum.reduce(0, fn line, acc ->
  [their, my] = String.split(line)
  acc + RockPaperScissors.resolve_part_1(my, their)
end)
|> IO.puts

input
|> Enum.reduce(0, fn line, acc ->
  [their, my] = String.split(line)
  acc + RockPaperScissors.resolve_part_2(my, their)
end)
|> IO.puts
