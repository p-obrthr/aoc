use std::fs;

fn main() {
    let input: String = fs::read_to_string("./input.txt")
        .unwrap()
        .trim_end()
        .to_string();

    println!("part_one: {}", find_marker(&input, 4));
    println!("part_two: {}", find_marker(&input, 14));
}

fn find_marker(input: &str, window_size: usize) -> usize {
    let found: (usize, String) = (0..input.chars().count())
        .map(|i| input.chars().skip(i).take(window_size).collect::<String>())
        .enumerate()
        .find(|(_, sequence)| all_unique(sequence))
        .unwrap();

    found.0 + window_size
}

fn all_unique(sequence: &str) -> bool {
    let chars: Vec<char> = sequence.chars().collect();
    chars
        .iter()
        .enumerate()
        .all(|(i, c)| !chars[i + 1..].contains(c))
}
