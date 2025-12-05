fn main() {
    let input: String = std::fs::read_to_string("./input.txt")
        .unwrap()
        .trim_end()
        .to_string();

    let numbers: Vec<i32> = input
        .lines()
        .map(|line| {
            let direct = if line.starts_with('L') { -1 } else { 1 };
            direct * line[1..].parse::<i32>().unwrap()
        })
        .collect();

    println!("part_one: {}", part_one(&numbers));
    println!("part_two: {}", part_two(&numbers));
}

fn part_one(numbers: &Vec<i32>) -> usize {
    let mut current = 50;

    numbers
        .iter()
        .filter_map(|&x| {
            current = (current + x).rem_euclid(100);
            (current == 0).then_some(0)
        })
        .count()
}

fn part_two(numbers: &Vec<i32>) -> i32 {
    let mut current: i32 = 50;
    let mut total: i32 = 0;

    for &number in numbers {
        let mut result = current + number;
        let mut count = 0;

        if current == 0 && result < 0 {
            count -= 1;
        }

        while result < 0 || result > 100 {
            if result < 0 {
                result = 100 + result;
            } else {
                result = -100 + result;
            }
            count += 1;
        }

        if result == 100 {
            result = 0;
        }

        if result == 0 {
            count += 1;
        }

        current = result;
        total += count;
    }

    total
}
