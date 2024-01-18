const std = @import("std");

pub fn main() !void {
    var input_file = try std.fs.cwd().openFile("9.txt", .{});
    defer input_file.close();

    var buf_reader = std.io.bufferedReader(input_file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;

    var nice_count: u32 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        if (isNice(line)) {
            nice_count += 1;
        }
    }

    std.debug.print("total nice words: {}\n", .{nice_count});
}

fn isNice(word: []u8) bool {
    var prev_char: u8 = 0x01;
    var vowels: u8 = 0;
    var double_letter = false;

    for (word) |char| {
        if (isNaughty(prev_char, char) == true) { return false; }
        else if (prev_char == char) { double_letter = true; }

        if (isVowel(char) == true) { vowels +|= 1; }

        prev_char = char;
    }

    return vowels >= 3 and double_letter;
}

fn isNaughty(prev_char: u8, char: u8) bool {
    return (prev_char == 'a' and char == 'b') or
           (prev_char == 'c' and char == 'd') or
           (prev_char == 'p' and char == 'q') or
           (prev_char == 'x' and char == 'y');
}

fn isVowel(char: u8) bool {
    return char == 'a' or char == 'e' or char == 'i' or char == 'o' or char == 'u';
}
