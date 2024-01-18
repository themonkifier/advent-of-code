//! The next year, to speed up the process, Santa creates a robot version of himself, Robo-Santa, to deliver presents with him.
//! Santa and Robo-Santa start at the same location (delivering two presents to the same starting house), then take turns moving based on instructions from the elf,
//!  who is eggnoggedly reading from the same script as the previous year.
//! This year, how many houses receive at least one present?
//! For example:
//!     ^v delivers presents to 3 houses, because Santa goes north, and then Robo-Santa goes south.
//!     ^>v< now delivers presents to 3 houses, and Santa and Robo-Santa end up back where they started.
//!     ^v^v^v^v^v now delivers presents to 11 houses, with Santa going one direction and Robo-Santa going the other.

const std = @import("std");

const Point = struct { x: i64, y: i64 };

pub fn main() !void {
    const input_file = try std.fs.cwd().openFile("5.txt", .{});
    defer input_file.close();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    var buf_reader = std.io.bufferedReader(input_file.reader());
    var in_stream = buf_reader.reader();

    var buf: [8192]u8 = undefined;

    var num_houses: u32 = 1;
    const chars_read = try in_stream.readAll(&buf);

    var visited_houses = std.AutoHashMap(Point, void).init(allocator);
    defer visited_houses.deinit();

    var santa = Point{ .x = 0, .y = 0 };
    var robo_santa = Point{ .x = 0, .y = 0 };
    try visited_houses.put(santa, {});
    for (buf[0..chars_read], 0..) |char, i| {
        const res = switch (i % 2) {
            0 => ret: {
                updateLocation(&santa, char);
                break :ret try visited_houses.getOrPut(santa);
            },
            1 => ret: {
                updateLocation(&robo_santa, char);
                break :ret try visited_houses.getOrPut(robo_santa);
            },
            else => unreachable,
        };

        num_houses += if (res.found_existing) 0 else 1;
    }

    std.debug.print("{} houses get at least 1 present\n", .{num_houses});
}

fn updateLocation(which_santa: *Point, char: u8) void {
    switch (char) {
        '<' => {
            which_santa.*.x -= 1;
        },
        '>' => {
            which_santa.*.x += 1;
        },
        '^' => {
            which_santa.*.y -= 1;
        },
        'v' => {
            which_santa.*.y += 1;
        },
        else => unreachable,
    }
}
