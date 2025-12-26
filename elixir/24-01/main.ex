defmodule Main do
  def get_data(file_name) do
    File.read!(file_name) 
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> 
         line 
         |> String.split() 
         |> Enum.map(&String.to_integer/1) 
         |> List.to_tuple() 
       end)
    |> Enum.unzip()
  end

  def part_one(file_name) do
    get_data(file_name)
    |> (fn {xs, ys} -> 
         Enum.zip(Enum.sort(xs), Enum.sort(ys))
        end).()
    |> Enum.map(fn {x, y} -> abs(x - y) end)
    |> Enum.sum()
  end

  def part_two(file_name) do
    get_data(file_name)
    |> (fn {xs, ys} ->
         xs 
         |> Enum.map(fn num -> 
              Enum.count(ys, fn y -> y == num end) * num
            end)
        end).()
    |> Enum.sum()
  end

end

IO.puts("""
[part_one] sample: #{Main.part_one("sample.txt")}
           input:  #{Main.part_one("input.txt")}
[part_two] sample: #{Main.part_two("sample.txt")}
           input:  #{Main.part_two("input.txt")}
""")
