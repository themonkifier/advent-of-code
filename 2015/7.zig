const std = @import("std");
const print = std.debug.print;
const md5 = std.crypto.hash.Md5;

pub fn main() !void {
    var args = try std.process.argsWithAllocator(std.heap.page_allocator);
    defer args.deinit();

    if (args.skip() == false) {
        print("not enough command line args (don't forget the key)\n", .{});
        std.process.exit(1);
    }

    _ = md5.init(.{});

    var key = [_]u8{0} ** 32;

    const base = args.next().?;
    _ = try std.fmt.bufPrint(&key, "{s}", .{base});

    var out = [_]u8{0} ** md5.digest_length;
    var i: u32 = 0;

    while (true) {
        _ = try std.fmt.bufPrint(key[base.len..], "{}", .{i});
        md5.hash(key[0 .. base.len + intLen(i)], &out, .{});
        print("trying {s}\n", .{key});
        print("got {x}\n", .{out});

        if (isAnswer(&out)) {
            print("{s} worked!\n", .{key});
            break;
        }

        i += 1;
    }
}

const answer = [_]u8{0, 0, 0, 0, 0, 0, 0, 0};
fn isAnswer(key: []const u8) bool {
    for (0..2) |i| {
        if (key[i] != answer[i]) {
            return false;
        }
    }

    return key[2] < 0x10;
}

fn intLen(i: u32) usize {
    return switch (i) {
        0 => 1,
        else => std.math.log10(i) + 1,
    };
}
