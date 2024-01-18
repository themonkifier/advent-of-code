//! Santa is delivering presents to an infinite two-dimensional grid of houses.
//! He begins by delivering a present to the house at his starting location, and then an elf at the North Pole calls him via radio and tells him where to move next.
//! Moves are always exactly one house to the north (^),
//!  south (v), east (>), or west (<). After each move, he delivers another present to the house at his new location.
//! However, the elf back at the north pole has had a little too much eggnog, and so his directions are a little off,
//!  and Santa ends up visiting some houses more than once. How many houses receive at least one present?
//! For example:
//!     `>` delivers presents to 2 houses: one at the starting location, and one to the east.
//!     `^>v<` delivers presents to 4 houses in a square, including twice to the house at his starting/ending location.
//!     `^v^v^v^v^v` delivers a bunch of presents to some very lucky children at only 2 houses.

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

    var current_house = Point{ .x = 0, .y = 0 };
    try visited_houses.put(current_house, {});
    for (buf[0..chars_read]) |char| {
        switch (char) {
            '<' => {
                current_house.x -= 1;
            },
            '>' => {
                current_house.x += 1;
            },
            '^' => {
                current_house.y -= 1;
            },
            'v' => {
                current_house.y += 1;
            },
            else => unreachable,
        }

        const res = try visited_houses.getOrPut(current_house);
        num_houses += if (res.found_existing) 0 else 1;
    }

    std.debug.print("{} houses get at least 1 present\n", .{num_houses});
}
