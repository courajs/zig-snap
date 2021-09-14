const std = @import("std");
const io = std.io;

pub fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic add functionality" {
    const t = std.testing;

    const dir_path = "/Users/outwards/dev/snap";
    var dir = try std.fs.openDirAbsolute(dir_path, .{});
    defer dir.close();

    {
        var file = try dir.createFile("thing.txt", .{});
        defer file.close();
        try file.writeAll("hello");
    }

    {
        var file = try dir.openFile("thing.txt", .{});
        defer file.close();

        var contents = try file.readToEndAlloc(t.allocator, 10);
        defer t.allocator.free(contents);

        try t.expectEqualStrings(contents, "hello");
    }
}

fn pipeAll(comptime buf_size: comptime_int, r: anytype, w: anytype) !usize {
    var buf: [buf_size]u8 = undefined;
    var read: usize = 0;
    var written: usize = 0;
    var total_read: usize = 0;
    var total_written: usize = 0;

    while (true) {
        written = 0;
        read = try r.read(&buf);
        total_read += read;
        if (read == 0) {
            break;
        }
        while (written < read) {
            written += try w.write(buf[written..read]);
        }
        total_written += written;
    }
    return total_written;
}
