const std = @import("std");
const testing = std.testing;

pub fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic add functionality" {
    const t = std.testing;

    var s = "hello\n";
    // read this from a file
    var buf = [_]u8{0} ** 16;

    const dir_path = "/Users/outwards/dev/snap";
    var dir = try std.fs.openDirAbsolute(dir_path, .{});
    defer dir.close();

    var file = try dir.openFile("thing.txt", .{});
    defer file.close();

    var len = try file.readAll(&buf);

    var slicee: []const u8 = buf[0..len];

    try t.expectEqual(len, 6);
    try t.expectEqualStrings(slicee, s);
}
