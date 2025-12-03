use std::fs;

fn main() {
    let input: String = fs::read_to_string("./input.txt")
        .unwrap()
        .trim_end()
        .to_string();

    let line_numbers: Vec<Vec<i32>> = input
        .lines()
        .map(|line| line.chars().map(|c| c as i32 - 0x30).collect::<Vec<i32>>())
        .collect();

    println!("part_one: {}", get_battery_sum(&line_numbers, 2));
    println!("part_two: {}", get_battery_sum(&line_numbers, 12));
}

fn get_battery_sum(line_numbers: &Vec<Vec<i32>>, count: usize) -> i64 {
    line_numbers
        .iter()
        .map(|line| {
            let mut number: i64 = 0;
            let mut start: usize = 0;

            for i in (0..count).rev() {
                let part = &line[start..line.len() - i];

                let &highest = part.iter().max().unwrap();
                let index = part.iter().position(|&x| x == highest).unwrap();

                number = number * 10 + highest as i64;
                start += index + 1;
            }

            number
        })
        .sum()
}
