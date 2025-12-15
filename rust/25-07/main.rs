use std::collections::HashSet;
use std::fs;

fn read_file(path: &str) -> String {
    fs::read_to_string(path).unwrap().trim_end().to_string()
}

fn part_one(input: &str) -> usize {
    let start: usize = input.lines().next().unwrap().find(|x| x == 'S').unwrap();
    let mut beams = HashSet::from([start]);

    let mut count: usize = 0;

    for line in input.lines().skip(1) {
        let mut beams_change = HashSet::new();

        for &beam in &beams {
            if line.chars().nth(beam).unwrap() == '^' {
                count += 1;
                beams_change.insert(beam + 1);
                beams_change.insert(beam - 1);
            } else {
                beams_change.insert(beam);
            }
        }

        beams = beams_change;
    }

    count
}

fn part_two(input: &str) -> u64 {
    let grid: Vec<Vec<char>> = input.lines().map(|x| x.chars().collect()).collect();
    let width: usize = grid[0].len();
    let mut paths: Vec<u64> = vec![0u64; width];

    let start: usize = input.lines().next().unwrap().find(|x| x == 'S').unwrap();
    paths[start] = 1;

    for row in 1..grid.len() {
        let mut paths_change = vec![0u64; width];
        for col in 0..width {
            if paths[col] == 0 {
                continue;
            }

            if grid[row][col] == '^' {
                paths_change[col - 1] += paths[col];
                paths_change[col + 1] += paths[col];
            } else {
                paths_change[col] += paths[col];
            }
        }
        paths = paths_change;
    }

    paths.iter().sum()
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
