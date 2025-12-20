use std::fs;

fn read_file(path: &str) -> String {
    fs::read_to_string(path).unwrap().trim_end().to_string()
}

fn check(pair: (i32, i32)) -> (bool, bool) {
    let diff = (pair.1 - pair.0).abs();
    let valid = diff >= 1 && diff <= 3;
    let dir = pair.0 < pair.1;
    (valid, dir)
}

fn is_valid(nums: &[i32]) -> bool {
    let mut pairs = nums.iter().zip(nums.iter().skip(1));
    let (&a, &b) = pairs.next().unwrap();
    let (first_valid, target_dir) = check((a, b));
    if !first_valid {
        return false;
    }

    pairs.all(|(&x, &y)| {
        let (valid, dir) = check((x, y));
        valid && dir == target_dir
    })
}

fn filter_valid<F>(input: &str, validator: F) -> Vec<Vec<i32>>
where
    F: Fn(&Vec<i32>) -> bool,
{
    input
        .lines()
        .filter_map(|line| {
            let nums = line
                .split_whitespace()
                .map(|n| n.parse::<i32>().unwrap())
                .collect();
            validator(&nums).then_some(nums)
        })
        .collect()
}

fn part_one(input: &str) -> i32 {
    filter_valid(input, |nums| is_valid(nums)).len() as i32
}

fn part_two(input: &str) -> i32 {
    filter_valid(input, |nums| {
        (0..nums.len()).any(|i| {
            let mut reduced = nums.clone();
            reduced.remove(i);
            is_valid(&reduced)
        })
    })
    .len() as i32
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
