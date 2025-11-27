use std::fs;

fn main() {
    let input: String = fs::read_to_string("./input.txt")
        .unwrap()
        .trim_end()
        .to_string();

    let lines: Vec<&str> = input.lines().collect();
    let letters_to_numbers: Vec<(char, i32)> = create_dic();

    println!("part_one: {}", part_one(&lines, &letters_to_numbers));
    println!("part_two: {}", part_two(&lines, &letters_to_numbers));
}

fn part_one(lines: &Vec<&str>, dic: &Vec<(char, i32)>) -> i32 {
    let compartments: Vec<(String, String)> = lines
        .iter()
        .map(|&line| {
            let chars_count = line.chars().count() / 2;
            (
                line.chars().take(chars_count).collect(),
                line.chars().skip(chars_count).take(chars_count).collect(),
            )
        })
        .collect();

    compartments
        .iter()
        .map(|(x, y)| {
            let found_char = x.chars().find(|&c| y.chars().any(|ch| ch == c)).unwrap();

            get_val(found_char, &dic)
        })
        .sum()
}

fn part_two(lines: &Vec<&str>, dic: &Vec<(char, i32)>) -> i32 {
    let compartments: Vec<(&str, &str, &str)> = lines
        .chunks(3)
        .map(|chunk| (chunk[0], chunk[1], chunk[2]))
        .collect();

    compartments
        .iter()
        .map(|(x, y, z)| {
            let found_char = x
                .chars()
                .find(|&c| y.chars().any(|ch| ch == c) && z.chars().any(|ch| ch == c))
                .unwrap();

            get_val(found_char, &dic)
        })
        .sum()
}

fn create_dic() -> Vec<(char, i32)> {
    let letters: Vec<char> = ('a'..='z').chain('A'..='Z').collect();
    let numbers: Vec<i32> = (1..53).collect();

    letters
        .iter()
        .zip(numbers.iter())
        .map(|(&c, &n)| (c, n)) // .map(|(c, n)| (*c, *n))
        .collect()
}

fn get_val(wanted: char, dic_thing: &Vec<(char, i32)>) -> i32 {
    dic_thing
        .iter()
        .find(|(key, _)| *key == wanted)
        .map(|(_, val)| *val)
        .unwrap_or(-1)
}
