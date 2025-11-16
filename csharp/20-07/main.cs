using System;

class Program
{
    static void Main()
    {
        string text = File.ReadAllText("input.txt"); 
        IEnumerable<string> lines = text.Split(".\n").Where(x => !string.IsNullOrEmpty(x));

        Dictionary<string, List<(int, string)>> entries = lines
            .Select(ProcessLine)
            .ToDictionary(x => x.key, x => x.subs);

        Console.WriteLine("PartOne: " + entries.ToList().Count(x => FindShiny(x.Key, entries)));
        Console.WriteLine("PartTwo: " + CountInside("shiny gold", entries));
    }

    static (string key, List<(int, string)> subs) ProcessLine(string line)
    {
        List<string> mainParts = line.Split(" contain ").ToList();  
        string key = mainParts[0].Replace(" bags", string.Empty);

        if(mainParts[1].StartsWith("no"))
        {
            return (key, []); 
        }

        List<(int, string)> subs = mainParts[1]
            .Split(", ")
            .Select(x => x.Split(" "))
            .Select(p => (int.Parse(p[0]), $"{p[1]} {p[2]}"))
            .ToList();

        return (key, subs);
    }
 
    static bool FindShiny(string key, Dictionary<string, List<(int _, string bagType)>> entries)
    {
        if(!entries.ContainsKey(key) || entries[key] is [])  
        {
            return false;
        }

        return entries[key].Any(x => x.bagType == "shiny gold") || entries[key].Any(x => FindShiny(x.bagType, entries));
    }

    static int CountInside(string key, Dictionary<string, List<(int count, string bagType)>> entries)
    {
        if (!entries.ContainsKey(key) || entries[key] is [])
        {
            return 0;
        }

        return entries[key].Sum(x => x.count * (1 + CountInside(x.bagType, entries)));
    }
}
