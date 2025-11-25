use std::fs;

fn main() {
    let input: String = fs::read_to_string("./input.txt")
        .unwrap()
        .trim_end()
        .to_string();

    let pairs: Vec<Vec<&str>> = input
        .split("\n")
        .map(|x| x.split_whitespace().collect())
        .collect();

    let part_one: Vec<i32> = pairs.iter().map(|x| get_score(x)).collect();
    let part_one_sum: i32 = part_one.iter().sum();

    let part_two: Vec<i32> = pairs.iter().map(|x| get_inst(x)).collect();
    let part_two_sum: i32 = part_two.iter().sum();

    println!("partOne: {}", part_one_sum);
    println!("partTwo: {}", part_two_sum);
}

fn get_score(pair: &Vec<&str>) -> i32 {
    let base = match (pair[0], pair[1]) {
        ("A", "X") | ("B", "Y") | ("C", "Z") => 3,
        ("A", "Y") | ("B", "Z") | ("C", "X") => 6,
        _ => 0,
    };

    base + get_points_for_shape(pair[1])
}

fn get_points_for_shape(shape: &str) -> i32 {
    match shape {
        "Y" => 2,
        "X" => 1,
        "Z" => 3,
        _ => -1,
    }
}

fn get_win(shape: &str) -> String {
    let res = match shape {
        "A" => "Y",
        "B" => "Z",
        "C" => "X",
        _ => "",
    };
    res.to_string()
}

fn get_draw(shape: &str) -> String {
    let res = match shape {
        "A" => "X",
        "B" => "Y",
        "C" => "Z",
        _ => "",
    };
    res.to_string()
}

fn get_loose(shape: &str) -> String {
    let res = match shape {
        "A" => "Z",
        "B" => "X",
        "C" => "Y",
        _ => "",
    };
    res.to_string()
}

fn get_inst(pair: &Vec<&str>) -> i32 {
    let res = match pair[1] {
        "X" => get_loose(pair[0]),
        "Y" => get_draw(pair[0]),
        "Z" => get_win(pair[0]),
        _ => "".to_string(),
    };

    let x: Vec<&str> = [pair[0], &res].to_vec();
    get_score(&x)
}
