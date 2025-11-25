use std::fs;

fn main() {
    let input: String = fs::read_to_string("./input.txt")
        .unwrap()
        .trim_end()
        .to_string();

    let numbers: Vec<i32> = input
        .split("\n\n")
        .map(|x| x.split("\n").map(|y| y.parse::<i32>().unwrap()).sum())
        .collect();

    let part_one: i32 = *get_biggest(&numbers);
    let part_two: i32 = get_three_biggest(&numbers).iter().sum();

    println!("part one: {}", part_one);
    println!("part two: {}", part_two);
}

fn get_biggest(numbers: &Vec<i32>) -> &i32 {
    numbers.iter().max().unwrap()
}

fn get_three_biggest(numbers: &Vec<i32>) -> [i32; 3] {
    let mut top = [0, 0, 0];

    for &num in numbers.iter() {
        if num > top[0] {
            top[2] = top[1];
            top[1] = top[0];
            top[0] = num;
        } else if num > top[1] {
            top[2] = top[1];
            top[1] = num;
        } else if num > top[2] {
            top[2] = num;
        }
    }

    top
}
