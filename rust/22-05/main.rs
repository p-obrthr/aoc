use std::fs;

fn main() {
    let input: String = fs::read_to_string("./input.txt")
        .unwrap()
        .trim_end()
        .to_string();

    let (crates_str, instructions_str): (&str, &str) = input.split_once("\n\n").unwrap();

    let mut crates_part_one: Vec<Vec<char>> = get_crates(&crates_str);
    let mut crates_part_two: Vec<Vec<char>> = crates_part_one.clone();

    let instructions: Vec<(i32, i32, i32)> = get_instructions(&instructions_str);

    instructions.iter().for_each(|inst| {
        process_instruction(&mut crates_part_one, &inst, false);
        process_instruction(&mut crates_part_two, &inst, true);
    });

    println!("part_one: {}", get_top_crates_combined(&crates_part_one));
    println!("part_two: {}", get_top_crates_combined(&crates_part_two));
}

fn get_crates(crates_str: &str) -> Vec<Vec<char>> {
    let lines: Vec<&str> = crates_str.lines().collect();
    let crate_count: usize = lines
        .last()
        .unwrap()
        .split_whitespace()
        .collect::<Vec<&str>>()
        .len();

    let untransposed: Vec<Vec<String>> = lines[..lines.len() - 1]
        .to_vec()
        .iter()
        .map(|line| {
            (0..crate_count)
                .map(|i| {
                    let c = line.chars().nth(i * 4 + 1).unwrap();
                    if c == ' ' {
                        String::new()
                    } else {
                        c.to_string()
                    }
                })
                .collect()
        })
        .rev()
        .collect();

    (0..untransposed[0].len())
        .map(|i| {
            untransposed
                .iter()
                .filter_map(|x| {
                    if !x[i].is_empty() {
                        Some(x[i].chars().next().unwrap())
                    } else {
                        None
                    }
                })
                .collect()
        })
        .collect()
}

fn get_instructions(instructions_str: &str) -> Vec<(i32, i32, i32)> {
    let lines: Vec<&str> = instructions_str.lines().collect();
    lines
        .iter()
        .map(|x| x.split_whitespace().collect::<Vec<&str>>())
        .map(|x| [1, 3, 5].map(|i| x[i].parse::<i32>().unwrap()))
        .map(|x| (x[0], x[1], x[2]))
        .collect()
}

fn process_instruction(
    crates: &mut Vec<Vec<char>>,
    &(take, from, to): &(i32, i32, i32),
    with_reverse: bool,
) {
    let from_index: usize = (from - 1) as usize;
    let to_index: usize = (to - 1) as usize;

    let mut to_moves: Vec<char> = (0..take).filter_map(|_| crates[from_index].pop()).collect();

    if with_reverse {
        to_moves.reverse();
    }

    to_moves.iter().for_each(|&c| {
        crates[to_index].push(c);
    });
}

fn get_top_crates_combined(crates: &Vec<Vec<char>>) -> String {
    crates.iter().filter_map(|x| x.last()).collect()
}
