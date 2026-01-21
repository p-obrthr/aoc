// 0.15.2
const std = @import("std");

const cub = struct { l: u8, w: u8, h: u8 };

fn getSquareFeet(dim: cub) u32 {
    return 2 * @as(u32, dim.l) * @as(u32, dim.w) + 2 * @as(u32, dim.w) * @as(u32, dim.h) + 2 * @as(u32, dim.h) * @as(u32, dim.l);
}

fn getFeetOfSlack(dim: cub) u32 {
    var slack: u32 = @as(u32, dim.l) * @as(u32, dim.w);
    if (@as(u32, dim.w) * @as(u32, dim.h) < slack) slack = @as(u32, dim.w) * @as(u32, dim.h);
    if (@as(u32, dim.h) * @as(u32, dim.l) < slack) slack = @as(u32, dim.h) * @as(u32, dim.l);
    return slack;
}

fn getRibbonFeet(dim: cub) u32 {
    var biggest: u8 = 0;

    if (dim.l > biggest) biggest = dim.l;
    if (dim.w > biggest) biggest = dim.w;
    if (dim.h > biggest) biggest = dim.h;

    if (biggest == dim.l) return @as(u32, dim.w) * 2 + @as(u32, dim.h) * 2;
    if (biggest == dim.w) return @as(u32, dim.l) * 2 + @as(u32, dim.h) * 2;
    if (biggest == dim.h) return @as(u32, dim.l) * 2 + @as(u32, dim.w) * 2;
    return 0;
}

fn getRibbonBow(dim: cub) u32 {
    return @as(u32, dim.l) * @as(u32, dim.w) * @as(u32, dim.h);
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var file = try std.fs.cwd().openFile("input.txt", .{ .mode = .read_only });
    defer file.close();

    const stat = try file.stat();
    const buff = try file.readToEndAlloc(allocator, stat.size);
    defer allocator.free(buff);

    var lines = std.mem.splitSequence(u8, buff, "\n");

    var wrap_of_paper: u32 = 0;
    var ribbon: u32 = 0;

    while (lines.next()) |line| {
        if (line.len == 0) continue;

        var nums = std.mem.splitSequence(u8, line, "x");

        const item: cub = .{
            .l = try std.fmt.parseInt(u8, nums.next().?, 10),
            .w = try std.fmt.parseInt(u8, nums.next().?, 10),
            .h = try std.fmt.parseInt(u8, nums.next().?, 10),
        };

        //std.debug.print("{d} {d} {d}\n", .{ item.l, item.w, item.h });

        const square_feet: u32 = getSquareFeet(item);
        const feet_of_slack: u32 = getFeetOfSlack(item);
        wrap_of_paper += square_feet + feet_of_slack;

        const ribbon_feet: u32 = getRibbonFeet(item);
        const ribbon_bow: u32 = getRibbonBow(item);
        ribbon += ribbon_feet + ribbon_bow;
    }

    std.debug.print("partOne: {d}\n", .{wrap_of_paper});
    std.debug.print("partTwo: {d}\n", .{ribbon});
}
