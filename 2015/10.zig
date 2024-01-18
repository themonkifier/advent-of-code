const std = @import("std");

pub fn main() !void {
    var input_file = try std.fs.cwd().openFile("9.txt", .{});
    defer input_file.close();

    var buf_reader = std.io.bufferedReader(input_file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;

    const words = [_] []const u8 { "qjhvhtzxzqqjkmpb", "xxyxx", "uurcxstgmygtbstg", "ieodomkazucvgmuy", "aaa" };

    for (words) |word| {
        std.debug.print("{s} {}\n", .{ word, try isNice(word) });
    }

    var nice_count: u32 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        if (try isNice(line)) {
            nice_count += 1;
        }
    }

    std.debug.print("total nice words: {}\n", .{nice_count});
}

fn isNice(word: []const u8) error{OutOfMemory}!bool {
    var set = std.AutoHashMap([2]u8, void).init(std.heap.page_allocator);
    defer set.deinit();

    var prev_char: u8 = 0x00;
    var prev_prev: u8 = 0x00;
    var double_letter = false;
    var double_pair = false;
    var timeout: u8 = 0;

    for (word) |char| {
        if (prev_prev == char) { double_letter = true; }

        else if (!double_pair and timeout == 0 and set.contains([2]u8{ prev_char, char })) {
            timeout = 1;
            double_pair = true;
        } else if (prev_char != 0x00) {
            try set.put([2]u8{ prev_char, char }, {});
        }

        if (timeout == 1) {
            timeout = 2;
        } else if (timeout == 2) {
            timeout = 0;
        }

        prev_prev = prev_char;
        prev_char = char;
    }

    return double_letter and double_pair;
}
