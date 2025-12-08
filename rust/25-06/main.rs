use std::fs;

fn main() {
    let input: String = fs::read_to_string("./input.txt").unwrap().to_string();
    let lines: Vec<&str> = input.lines().collect();

    println!("part_one: {}", part_one(&lines));
    println!("part_two: {}", part_two(&lines));
}

fn part_one(lines: &Vec<&str>) -> u64 {
    let worksheet: Vec<Vec<&str>> = lines
        .iter()
        .map(|&line| line.split_whitespace().collect::<Vec<&str>>())
        .collect();

    (0..worksheet[0].len())
        .map(|i| {
            let col: Vec<&str> = worksheet.iter().map(|row| row[i]).collect();
            let nums: Vec<u64> = col[..col.len() - 1]
                .iter()
                .map(|s| s.parse::<u64>().unwrap())
                .collect();

            match *col.last().unwrap() {
                "+" => nums.iter().sum(),
                "*" => nums.iter().product(),
                _ => 0,
            }
        })
        .sum()
}

fn part_two(lines: &Vec<&str>) -> u64 {
    let op_line: Vec<char> = lines.last().unwrap().chars().collect();

    let worksheet: Vec<String> = lines
        .iter()
        .enumerate()
        .map(|(row_ind, line)| {
            if row_ind == lines.iter().count() - 1 {
                return line.to_string();
            }

            let mut modded_line: Vec<char> = line.chars().collect();

            for i in 0..modded_line.len() {
                if modded_line[i] == ' '
                    && ((i + 1 < op_line.len() && op_line[i + 1] == ' ')
                        || (i == op_line.len() - 1))
                {
                    modded_line[i] = '0';
                }
            }

            modded_line.iter().collect::<String>()
        })
        .collect();

    let lines: Vec<Vec<&str>> = worksheet
        .iter()
        .map(|line| line.split_whitespace().collect::<Vec<&str>>())
        .collect();

    (0..lines[0].len())
        .rev()
        .map(|i| {
            let col: Vec<&str> = lines.iter().map(|row| row[i]).collect();

            let num_rows = &col[..col.len() - 1];

            let nums: Vec<u64> = (0..num_rows[0].len())
                .rev()
                .map(|i| {
                    let chars: String = num_rows
                        .iter()
                        .map(|row| row.chars().nth(i).unwrap())
                        .filter(|&c| c != '0')
                        .collect();

                    chars.parse::<u64>().unwrap()
                })
                .collect();

            match *col.last().unwrap() {
                "+" => nums.iter().sum(),
                "*" => nums.iter().product(),
                _ => 0,
            }
        })
        .sum()
}
