const std = @import("std");
const ascii = std.ascii;

const one: [3]u8 = .{ 'o', 'n', 'e' };
const two: [3]u8 = .{ 't', 'w', 'o' };
const three: [5]u8 = .{ 't', 'h', 'r', 'e', 'e' };
const four: [4]u8 = .{ 'f', 'o', 'u', 'r' };
const five: [4]u8 = .{ 'f', 'i', 'v', 'e' };
const six: [3]u8 = .{ 's', 'i', 'x' };
const seven: [5]u8 = .{ 's', 'e', 'v', 'e', 'n' };
const eight: [5]u8 = .{ 'e', 'i', 'g', 'h', 't' };
const nine: [4]u8 = .{ 'n', 'i', 'n', 'e' };

pub fn main() !void {
    var sum: u32 = 0;

    var file = try std.fs.cwd().openFile("./data/01.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buf: [1024]u8 = undefined;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        // do something with line...

        var f: u8 = 0;
        var l: u8 = 0;
        var start: [5]u8 = .{ 0, 0, 0, 0, 0 };
        var end: [5]u8 = .{ 0, 0, 0, 0, 0 };
        std.debug.print("the line is: {s}\n", .{line});

        for (line, 0..) |c, i| {
            start[i] = c;
            if (std.mem.eql(u8, &start[0..3], &one)) {
                f = 1;
                break;
            }
            if (&start[0..3] == two) {
                f = 2;
                break;
            }
            if (&start[0..5] == three) {
                f = 3;
                break;
            }
            if (&start[0..4] == four) {
                f = 4;
                break;
            }
            if (&start[0..4] == five) {
                f = 5;
                break;
            }
            if (&start[0..3] == six) {
                f = 6;
                break;
            }
            if (&start[0..5] == seven) {
                f = 7;
                break;
            }
            if (&start[0..5] == eight) {
                f = 8;
                break;
            }
            if (&start[0..4] == nine) {
                f = 9;
                break;
            }
            if (ascii.isDigit(c) and f == 0) {
                const s: [1]u8 = .{c};
                f = try std.fmt.parseInt(u8, &s, 10);
                std.debug.print("this is f: {}\n", .{f});
                break;
            }
        }
        var i = line.len - 1;
        while (i >= 0 and l == 0) : (i -= 1) {
            const c = line[i];
            end[i] = c;
            if (end[2..5] == one) {
                l = 1;
                break;
            }
            if (end[2..5] == two) {
                l = 2;
                break;
            }
            if (end[0..5] == three) {
                l = 3;
                break;
            }
            if (end[1..5] == four) {
                l = 4;
                break;
            }
            if (end[1..5] == five) {
                l = 5;
                break;
            }
            if (end[2..5] == six) {
                l = 6;
                break;
            }
            if (end[0..5] == seven) {
                l = 7;
                break;
            }
            if (end[0..5] == eight) {
                l = 8;
                break;
            }
            if (end[2..5] == nine) {
                l = 9;
                break;
            }
            if (ascii.isDigit(c) and l == 0) {
                const s: [1]u8 = .{c};
                l = try std.fmt.parseInt(u8, &s, 10);
                std.debug.print("this is l: {}\n", .{l});
                break;
            }
        }
        sum += 10 * f;
        sum += l;
    }

    std.debug.print("the sum is {}", .{sum});
}
