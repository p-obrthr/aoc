fn main() {
    let input: String = std::fs::read_to_string("./input.txt")
        .unwrap()
        .trim_end()
        .to_string();

    let (ranges, prooves) = process_input(&input);

    println!("part_one: {}", get_freshes_count(&prooves, &ranges));
    println!("part_two: {}", get_considered_count(&ranges));
}

fn process_input(input: &str) -> (Vec<(u64, u64)>, Vec<u64>) {
    let (ranges_str, ids_str): (&str, &str) = input.split_once("\n\n").unwrap();

    let mut ranges: Vec<(u64, u64)> = ranges_str
        .lines()
        .map(|line| {
            let (a, b) = line.split_once('-').unwrap();
            (a.parse().unwrap(), b.parse().unwrap())
        })
        .collect();

    ranges.sort_by_key(|r| r.0);

    let mut merged: Vec<(u64, u64)> = Vec::new();

    for (start, end) in ranges {
        if merged.is_empty() {
            merged.push((start, end));
            continue;
        }

        let last = merged.last_mut().unwrap();

        if start <= last.1 + 1 {
            last.1 = last.1.max(end);
        } else {
            merged.push((start, end));
        }
    }

    let prooves: Vec<u64> = ids_str.lines().map(|x| x.parse::<u64>().unwrap()).collect();

    (merged, prooves)
}

fn get_freshes_count(prooves: &Vec<u64>, ranges: &Vec<(u64, u64)>) -> usize {
    prooves
        .iter()
        .filter_map(|&x| is_in_ranges(x, &ranges).then(|| x))
        .count()
}

fn is_in_ranges(id: u64, ranges: &Vec<(u64, u64)>) -> bool {
    let mut left: usize = 0;
    let mut right = ranges.len() - 1;
    let mut mid = (left + right) / 2;
    let mut current = ranges[mid];

    while left <= right {
        let (start, end) = current;

        if id >= start && id <= end {
            return true;
        } else if id < start {
            if mid == 0 {
                break;
            }
            right = mid - 1;
        } else {
            left = mid + 1;
        }

        mid = (left + right) / 2;
        current = ranges[mid];
    }

    false
}

fn get_considered_count(ranges: &Vec<(u64, u64)>) -> u64 {
    ranges.iter().map(|&(start, end)| end - start + 1).sum()
}
