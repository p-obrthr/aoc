use std::fs;

fn main() {
    let input: String = fs::read_to_string("./input.txt")
        .unwrap()
        .trim_end()
        .to_string();
    let ranges: Vec<&str> = input.split(",").collect();

    let ids: Vec<(i64, i64)> = ranges
        .iter()
        .map(|x| {
            x.split("-")
                .map(|id| id.parse::<i64>().unwrap())
                .collect::<Vec<i64>>()
        })
        .map(|x| (x[0], x[1]))
        .collect();

    println!("part_one: {}", part_one(&ids));
    println!("part_two: {}", part_two(&ids));
}

fn part_one(ids: &Vec<(i64, i64)>) -> i64 {
    let filtered: Vec<Vec<i64>> = ids
        .iter()
        .map(|&(start, end)| {
            (start..end + 1)
                .filter_map(|x| {
                    let s: String = x.to_string();
                    let half: usize = s.len() / 2;

                    if s.len() % 2 == 0 && &s[..half] == &s[half..] {
                        Some(x)
                    } else {
                        None
                    }
                })
                .collect()
        })
        .collect();

    filtered.iter().map(|x| x.iter().sum::<i64>()).sum()
}

fn part_two(ids: &Vec<(i64, i64)>) -> i64 {
    let filtered: Vec<Vec<i64>> = ids
        .iter()
        .map(|&(start, end)| {
            (start..end + 1)
                .filter_map(|x| {
                    let s: String = x.to_string();
                    let len: usize = s.len();
                    let half: usize = len / 2;

                    for l in 1..(half + 1) {
                        if len % l == 0 {
                            let pattern = &s[..l];
                            let pattern_count: usize = len / l;
                            let mut repeated: String = String::new();
                            for _ in 0..(pattern_count) {
                                repeated.push_str(pattern);
                            }
                            if repeated == s {
                                return Some(x);
                            }
                        }
                    }
                    return None;
                })
                .collect()
        })
        .collect();

    filtered.iter().map(|x| x.iter().sum::<i64>()).sum()
}
