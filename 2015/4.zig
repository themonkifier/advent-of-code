//! The elves are also running low on ribbon. Ribbon is all the same width, so they only have to worry about the length they need to order, which they would again like to be exact.
//! The ribbon required to wrap a present is the shortest distance around its sides, or the smallest perimeter of any one face. Each present also requires a bow made out of ribbon as well;
//!  the feet of ribbon required for the perfect bow is equal to the cubic feet of volume of the present. Don't ask how they tie the bow, though; they'll never tell.
//! For example:
//!     A present with dimensions 2x3x4 requires 2+2+3+3 = 10 feet of ribbon to wrap the present plus 2*3*4 = 24 feet of ribbon for the bow, for a total of 34 feet.
//!     A present with dimensions 1x1x10 requires 1+1+1+1 = 4 feet of ribbon to wrap the present plus 1*1*10 = 10 feet of ribbon for the bow, for a total of 14 feet.
//! How many total feet of ribbon should they order?

const std = @import("std");

const Result = struct { x: u32, y: u32, z: u32 };

pub fn main() !void {
    var input_file = try std.fs.cwd().openFile("3.txt", .{});
    defer input_file.close();

    var buf_reader = std.io.bufferedReader(input_file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;

    var total_length: u32 = 0;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        total_length +|= try ribbon(line);
    }

    std.debug.print("total ribbon required: {} sq ft\n", .{total_length});
}

fn ribbon(line: []u8) !u32 {
    const res = atoi3(line);

    const bow: u32 = res.x * res.y * res.z;

    const side: u32 = if (res.x >= res.y and res.x >= res.z)
        2 * (res.y + res.z)
    else if (res.y >= res.x and res.y >= res.z)
        2 * (res.x + res.z)
    else
        2 * (res.x + res.y);

    return bow + side;
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
