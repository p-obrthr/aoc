// 0.15.2
const std = @import("std");

fn getChange(symbol: u8) i8 {
    if (symbol == '(') return 1;
    if (symbol == ')') return -1;
    return 0;
}

fn partOne(line: []const u8) i16 {
    var floor: i16 = 0;

    for (line) |symbol| {
        floor = floor + getChange(symbol);
        //std.debug.print("{u}\n", .{symbol});
    }

    return floor;
}

fn partTwo(line: []const u8) usize {
    var floor: i16 = 0;

    for (line, 0..) |symbol, i| {
        floor = floor + getChange(symbol);
        if (floor == -1) {
            return i + 1;
        }
    }

    return 0;
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var file = try std.fs.cwd().openFile("input.txt", .{ .mode = .read_only });
    defer file.close();

    const stat = try file.stat();
    const buff = try file.readToEndAlloc(allocator, stat.size);
    defer allocator.free(buff);

    var lines = std.mem.splitSequence(u8, buff, "\n");
    const line: []const u8 = lines.next() orelse return;

    std.debug.print("partOne: {d}\n", .{partOne(line)});
    std.debug.print("partTwo: {d}\n", .{partTwo(line)});
}
