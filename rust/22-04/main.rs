use std::fs;

fn main() {
    let input: String = fs::read_to_string("./input.txt")
        .unwrap()
        .trim_end()
        .to_string();

    let lines: Vec<&str> = input.lines().collect();

    let pairs: Vec<Vec<(i32, i32)>> = lines
        .iter()
        .map(|line| {
            line.split(",")
                .map(|part| {
                    let numbers: Vec<i32> =
                        part.split("-").map(|x| x.parse::<i32>().unwrap()).collect();
                    (numbers[0], numbers[1])
                })
                .collect()
        })
        .collect();

    println!("part_one: {}", part_one(&pairs));
    println!("part_two: {}", part_two(&pairs));
}

fn part_one(pairs: &Vec<Vec<(i32, i32)>>) -> usize {
    let inbounds: Vec<&Vec<(i32, i32)>> = pairs
        .iter()
        .filter(|&pair| {
            let first: (i32, i32) = pair[0];
            let second: (i32, i32) = pair[1];

            (first.0 <= second.0 && first.1 >= second.1)
                || (second.0 <= first.0 && second.1 >= first.1)
        })
        .collect();

    inbounds.len()
}

fn part_two(pairs: &Vec<Vec<(i32, i32)>>) -> usize {
    let overlaps: Vec<&Vec<(i32, i32)>> = pairs
        .iter()
        .filter(|&pair| {
            let first: (i32, i32) = pair[0];
            let second: (i32, i32) = pair[1];

            first.0 <= second.1 && second.0 <= first.1
        })
        .collect();

    overlaps.len()
}
