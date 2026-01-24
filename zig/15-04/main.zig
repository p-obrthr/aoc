const std = @import("std");
const hash = std.crypto.hash;

fn getHash(input: []const u8) [hash.Md5.digest_length]u8 {
    var out: [hash.Md5.digest_length]u8 = undefined;
    hash.Md5.hash(input, &out, .{});
    return out;
}

fn isValid(hex: []const u8, numZeros: usize) bool {
    for (hex, 1..) |x, i| {
        if (x != '0') return false;
        if (i == numZeros) break;
    }
    return true;
}

fn findNum(input: []const u8, numZeros: usize) u32 {
    var num: u32 = 1;
    var buf: [32]u8 = undefined;

    while (true) : (num += 1) {
        const str = std.fmt.bufPrint(&buf, "{s}{d}", .{
            input,
            num,
        }) catch unreachable;
        const hashVal = getHash(str);
        const hex = std.fmt.bytesToHex(hashVal, .lower);
        if (isValid(&hex, numZeros)) return num;
    }

    return 0;
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var file = try std.fs.cwd().openFile("input.txt", .{
        .mode = .read_only,
    });
    defer file.close();

    const stat = try file.stat();
    const buff = try file.readToEndAlloc(allocator, stat.size);
    defer allocator.free(buff);

    var lines = std.mem.splitSequence(u8, buff, "\n");
    const input: []const u8 = lines.next() orelse return;

    std.debug.print("partOne: {d}\n", .{findNum(input, 5)});
    std.debug.print("partTwo: {d}\n", .{findNum(input, 6)});
}
