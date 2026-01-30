// 0.15.2
const std = @import("std");
const allocator = std.heap.page_allocator;
const vowels = [_]u8{ 'a', 'e', 'i', 'o', 'u' };

fn containsVowels(input: []const u8) bool {
    var count: usize = 0;

    for (input) |iC| {
        for (vowels) |vC| {
            if (iC == vC) count += 1;
            if (count >= 3) return true;
        }
    }
    return false;
}

fn containsDoubles(str: []const u8) bool {
    for (0..(str.len - 1)) |i| {
        if (str[i] == str[i + 1]) return true;
    }
    return false;
}

fn notContainsStrs(input: []const u8) bool {
    const strs = [_][]const u8{ "ab", "cd", "pq", "xy" };
    for (strs) |str| {
        if (std.mem.indexOf(u8, input, str) != null) return false;
    }
    return true;
}

fn containsTwoLetterPairs(str: []const u8) bool {
    if (str.len < 4) return false;

    for (0..(str.len - 3)) |i| {
        const one: u8 = str[i];
        const two: u8 = str[i + 1];

        for ((i + 2)..(str.len - 1)) |j| {
            if (one == str[j] and two == str[j + 1]) return true;
        }
    }

    return false;
}

fn containsLetterRepeatsWithBetween(str: []const u8) bool {
    if (str.len < 3) return false;

    for (0..(str.len - 2)) |i| {
        if (str[i] == str[i + 2]) return true;
    }

    return false;
}

fn partOne(input: []const u8) bool {
    return containsVowels(input) and containsDoubles(input) and notContainsStrs(input);
}

fn partTwo(input: []const u8) bool {
    return containsTwoLetterPairs(input) and containsLetterRepeatsWithBetween(input);
}

pub fn main() !void {
    var file = try std.fs.cwd().openFile("input.txt", .{
        .mode = .read_only,
    });
    defer file.close();

    const stat = try file.stat();
    const buf = try file.readToEndAlloc(allocator, stat.size);

    defer allocator.free(buf);

    var lines = std.mem.splitSequence(u8, buf, "\n");

    var countPartOne: usize = 0;
    var countPartTwo: usize = 0;

    while (lines.next()) |line| {
        if (line.len == 0) continue;
        if (partOne(line)) countPartOne += 1;
        if (partTwo(line)) countPartTwo += 1;
    }

    std.debug.print("partOne: {d}\n", .{countPartOne});
    std.debug.print("partTwo: {d}\n", .{countPartTwo});
}
