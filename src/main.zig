const std = @import("std");
const io = std.io;

pub fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic add functionality" {
    const t = std.testing;

    const value = "hello";
    var input = std.io.fixedBufferStream(value);
    var output = std.ArrayList(u8).init(t.allocator);
    defer output.deinit();

    const dir_path = "/Users/outwards/dev/snap";
    var dir = try std.fs.openDirAbsolute(dir_path, .{});
    defer dir.close();

    {
        var file = try dir.createFile("thing.txt", .{});
        defer file.close();

        _ = try pipeAll(100, input.reader(), file.writer());
    }

    {
        var file = try dir.openFile("thing.txt", .{});
        defer file.close();
        _ = try pipeAll(100, file.reader(), output.writer());
    }

    try t.expectEqualStrings(value, output.items);
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
