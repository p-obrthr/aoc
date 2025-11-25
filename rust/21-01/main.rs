use std::fs;

fn main() {
    let input: String = fs::read_to_string("./input.txt").unwrap();

    let numbers: Vec<i32> = input
        .trim_end()
        .split("\n")
        .map(|x| x.parse::<i32>().unwrap())
        .collect();

    let part_one: i32 = numbers
        .iter()
        .zip(numbers.iter().skip(1))
        .map(|(x, y)| if x < y { 1 } else { 0 })
        .sum();

    println!("partOne: {part_one}");

    let mut sum_vec: Vec<i32> = Vec::new();

    for (a, (b, c)) in numbers
        .iter()
        .zip((numbers.iter().skip(1)).zip(numbers.iter().skip(2)))
    {
        let three_sum = a + b + c;
        sum_vec.push(three_sum);

        //println!("{a} {b} {c} {three_sum}");
    }

    let mut another_result: Vec<i32> = Vec::new();

    for (a, b) in sum_vec.iter().zip(sum_vec.iter().skip(1)) {
        //println!("{a} {b}");
        another_result.push(if a < b { 1 } else { 0 });
    }

    //println!("{:?}", another_result);

    let part_two_sum: i32 = another_result.iter().sum();

    println!("partTwo: {part_two_sum}")
}
