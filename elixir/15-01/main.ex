defmodule Main do
  def get_data(file_name) do
    File.read!(file_name) 
    |> String.trim_trailing() 
    |> String.graphemes()
  end

  defp change("("), do: 1
  defp change(")"), do: -1 

  defp find_basement([_ | _], acc, -1), do: acc
  defp find_basement([head | tail], acc, pos) do
    find_basement(tail, acc + 1, pos + change(head)) 
  end

  def part_one(file_name) do
    get_data(file_name)
    |> Enum.map(&(change(&1)))
    |> Enum.sum()
  end

  def part_two(file_name) do
    find_basement(get_data(file_name), 0, 0)
  end
end

IO.puts("""
[part_one] input: #{Main.part_one("input.txt")}
[part_two] input: #{Main.part_two("input.txt")}
""")
