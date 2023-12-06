const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    var file = try std.fs.cwd().openFile("./data/03.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buf: [1024]u8 = undefined;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        _ = line;
    }
}

test "test case" {
    const test_data = [_][]const u8{
        "467..114..",
        "...*......",
        "..35..633.",
        "......#...",
        "617*......",
        ".....+.58.",
        "..592.....",
        "......755.",
        "...$.*....",
        ".664.598..",
    };

    var sum: u64 = 0;

    var symbols: [10]u8 = [_]u8{0} ** 10;
    _ = symbols;
    var prev_symbols: [10]u8 = [_]u8{0} ** 10;

    var non_adj: [10]u8 = [_]u8{0} ** 10;
    _ = non_adj;
    var prev_non_adj: [10]u8 = [_]u8{0} ** 10;
    _ = prev_non_adj;

    for (test_data) |line| {
        var current_num: u64 = 0;
        for (line, 0..) |c, i| {
            if (std.ascii.isDigit(c)) {
                current_num *= 10;
                current_num += try std.fmt.parseInt(u8, &[1]u8{c}, 10);
            } else if (c == '.' and current_num != 0) {
                // here we know that we are right after a num, because we set current_num to 0 at the end of this
                // we need to find the length in digits of the number, our max is 3
                var len: u8 = 0;
                if (current_num < 10) {
                    len = 1;
                } else if (current_num < 100) {
                    len = 2;
                } else {
                    len = 3;
                }

                var start: u8 = 0;

                if (i - len - 1 > 0) {
                    start = i - len - 1;
                }

                const slice = prev_symbols[start..i];
                var adj = false;
                for (slice) |s| {
                    if (s == 1) {
                        sum += current_num;
                        adj = true;
                        break;
                    }
                }
                if (!adj) {
                    // TODO figure out how to track previous nums that are non_adj to do check in next line
                }
                current_num = 0;
            } else {}
        }
    }
}
