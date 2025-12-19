use std::fs;

fn read_file(path: &str) -> String {
    fs::read_to_string(path).unwrap().trim_end().to_string()
}

fn parse(input: &str) -> (Vec<i32>, Vec<i32>) {
    input
        .lines()
        .map(|line| {
            let mut nums = line.split_whitespace();
            (
                nums.next().unwrap().parse::<i32>().unwrap(),
                nums.next().unwrap().parse::<i32>().unwrap(),
            )
        })
        .unzip()
}

fn part_one(input: &str) -> i32 {
    let (mut left, mut right): (Vec<i32>, Vec<i32>) = parse(input);

    left.sort();
    right.sort();

    left.iter()
        .zip(&right)
        .map(|(&x, &y)| (x - y).abs())
        .sum::<i32>()
}

fn part_two(input: &str) -> i32 {
    let (left, right): (Vec<i32>, Vec<i32>) = parse(input);

    left.iter()
        .map(|&x| x * right.iter().filter(|&n| x == *n).count() as i32)
        .sum::<i32>()
}

fn main() {
    let sample: String = read_file("./sample.txt");
    let input: String = read_file("./input.txt");

    println!(
        "[part_one] sample: {}, input: {}",
        part_one(&sample),
        part_one(&input)
    );

    println!(
        "[part_two] sample: {}, input: {}",
        part_two(&sample),
        part_two(&input)
    );
}
