const std = @import("std");

fn fuel(num: i32) i32 {
    return @divFloor(num, 3) - 2;
}

fn process(num: i32) struct {
    one: i32,
    two: i32,
} {
    const first = fuel(num);

    var total: i32 = 0;
    var step = first;

    while (step > 0) {
        total += step;
        step = fuel(step);
    }

    return .{
        .one = first,
        .two = total,
    };
}

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const allocator = std.heap.page_allocator;

    const dir = try std.Io.Dir.cwd().openDir(io, ".", .{});
    const file = try dir.openFile(io, "input.txt", .{});
    defer file.close(io);

    var file_reader = file.reader(io, &.{});
    const input = try file_reader.interface.allocRemaining(allocator, .limited(1234));
    defer allocator.free(input);

    var lines = std.mem.splitSequence(u8, input, "\n");

    var partOne: i32 = 0;
    var partTwo: i32 = 0;

    while (lines.next()) |line| {
        if (line.len == 0) {
            continue;
        }

        const num = try std.fmt.parseInt(i32, line, 10);
        const result = process(num);

        partOne += result.one;
        partTwo += result.two;
    }

    std.debug.print("partOne: {d}\n", .{partOne});
    std.debug.print("partTwo: {d}\n", .{partTwo});
}
