// 0.15.2
const std = @import("std");

const Position = struct { x: i32, y: i32 };
const HashMap = std.AutoHashMap;

fn changePos(symbol: u8, pos: *Position, map: *HashMap(Position, u32)) !void {
    if (symbol == '>') pos.x += 1;
    if (symbol == 'v') pos.y -= 1;
    if (symbol == '^') pos.y += 1;
    if (symbol == '<') pos.x -= 1;

    try map.put(pos.*, 0);
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

    const start_pos: Position = .{ .x = 0, .y = 0 };

    var map_part_one: HashMap(Position, u32) = .init(allocator);
    defer map_part_one.deinit();
    var pos_santa_alone: Position = start_pos;
    try map_part_one.put(start_pos, 0);

    var map_part_two: HashMap(Position, u32) = .init(allocator);
    defer map_part_two.deinit();
    var pos_santa: Position = start_pos;
    var pos_robot_santa: Position = start_pos;
    try map_part_two.put(start_pos, 0);

    for (line, 1..) |symbol, i| {
        // partOne
        try changePos(symbol, &pos_santa_alone, &map_part_one);

        // partTwo
        if (i % 2 == 0) {
            try changePos(symbol, &pos_robot_santa, &map_part_two);
        } else {
            try changePos(symbol, &pos_santa, &map_part_two);
        }
    }

    std.debug.print("partOne: {d}\n", .{map_part_one.count()});
    std.debug.print("partTwo: {d}\n", .{map_part_two.count()});
}
