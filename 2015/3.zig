//! The elves are running low on wrapping paper, and so they need to submit an order for more. They have a list of the dimensions (length l, width w, and height h) of each present, and only want to order exactly as much as they need.
//! Fortunately, every present is a box (a perfect right rectangular prism), which makes calculating the required wrapping paper for each gift a little easier: find the surface area of the box, which is 2*l*w + 2*w*h + 2*h*l. The elves also need a little extra paper for each present: the area of the smallest side.
//! For example:
//!     A present with dimensions 2x3x4 requires 2*6 + 2*12 + 2*8 = 52 square feet of wrapping paper plus 6 square feet of slack, for a total of 58 square feet.
//!     A present with dimensions 1x1x10 requires 2*1 + 2*10 + 2*10 = 42 square feet of wrapping paper plus 1 square foot of slack, for a total of 43 square feet.
//! All numbers in the elves' list are in feet. How many total square feet of wrapping paper should they order?

const std = @import("std");

const Result = struct { x: u32, y: u32, z: u32 };

pub fn main() !void {
    var input_file = try std.fs.cwd().openFile("3.txt", .{});
    defer input_file.close();

    var buf_reader = std.io.bufferedReader(input_file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;

    var total_area: u32 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        total_area +|= try surfaceArea(line);
    }

    std.debug.print("total wrapping paper required: {} sq ft\n", .{total_area});
}

fn surfaceArea(line: []u8) !u32 {
    const res = atoi3(line);

    const top = res.x * res.y;
    const side = res.y * res.z;
    const front = res.z * res.x;

    return 2 * (top + side + front) + @min(top, side, front);
}

fn atoi3(line: []u8) Result {
    var result = Result{ .x = 0, .y = 0, .z = 0 };
    var structi: u2 = 0;

    var num: u32 = 0;
    for (line, 0..) |char, i| {
        if (char == 'x' or i == line.len) {
            switch (structi) {
                0 => {
                    result.x = num;
                },
                1 => {
                    result.y = num;
                },
                else => {
                    unreachable;
                },
            }

            structi += 1;
            num = 0;
            continue;
        }

        num *|= 10;
        num +|= (char -% '0');
    }

    result.z = num;
    return result;
}
