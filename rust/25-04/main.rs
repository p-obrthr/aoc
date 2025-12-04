use std::fs;

fn main() {
    let input: String = fs::read_to_string("./input.txt")
        .unwrap()
        .trim_end()
        .to_string();

    let grid: Vec<Vec<char>> = input
        .lines()
        .map(|line| line.chars().collect::<Vec<char>>())
        .collect();

    let neighbor_pos: Vec<(i32, i32)> = [
        (0, -1),
        (0, 1),
        (-1, 0),
        (1, 0),
        (-1, -1),
        (-1, 1),
        (1, -1),
        (1, 1),
    ]
    .to_vec();

    println!("part_one: {}", process(&grid, &neighbor_pos, true));
    println!("part_two: {}", process(&grid, &neighbor_pos, false));
}

fn process(grid: &Vec<Vec<char>>, neighbor_pos: &Vec<(i32, i32)>, single_iter: bool) -> i32 {
    let mut grid = grid.clone();
    let rows = grid.len();
    let cols = grid[0].len();
    let mut total = 0;

    loop {
        let mut changed = 0;
        let mut new_grid = grid.clone();

        for row in 0..rows {
            for col in 0..cols {
                if grid[row][col] == '@' {
                    let count = neighbor_pos
                        .iter()
                        .filter(|&(x, y)| {
                            let tx = row as i32 + x;
                            let ty = col as i32 + y;
                            tx >= 0
                                && tx < rows as i32
                                && ty >= 0
                                && ty < cols as i32
                                && grid[tx as usize][ty as usize] == '@'
                        })
                        .count();

                    if count < 4 {
                        new_grid[row][col] = 'x';
                        changed += 1;
                    }
                }
            }
        }

        total += changed;

        if single_iter || changed == 0 {
            break;
        }

        grid = new_grid;
    }

    total
}
