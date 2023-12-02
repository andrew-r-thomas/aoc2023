const std = @import("std");

pub fn main() !void {
    var file = try std.fs.cwd().openFile("./data/02.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buf: [1024]u8 = undefined;
    var sum: u64 = 0;
    var i: u64 = 0;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        std.debug.print("this is the current line:\n {s}\n", .{line});
        sum += try dothing(line, i);
        i += 1;
    }

    std.debug.print("the answer is: {d}\n", .{sum});
}

fn dothing(line: []const u8, i: u64) !u64 {
    var game: u64 = 0;
    var afterColon = false;
    var numBuf: u64 = 0;

    for (line, 0..) |c, j| {
        std.debug.print("this is the current char {c}\n", .{c});
        if (j == line.len - 1) {
            std.debug.print("done checking line\n", .{});
            game = i + 1;
            break;
        }
        if (c == ':') {
            std.debug.print("we got a colon\n", .{});
            afterColon = true;
            continue;
        }
        if (!afterColon) {
            std.debug.print("we not after colon\n", .{});
            continue;
        }
        if (std.ascii.isAlphabetic(c) and numBuf != 0) {
            std.debug.print("this is number: {}\n", .{numBuf});
            switch (c) {
                'b' => {
                    if (numBuf > 14) {
                        break;
                    }
                },
                'r' => {
                    if (numBuf > 12) {
                        break;
                    }
                },
                'g' => {
                    if (numBuf > 13) {
                        break;
                    }
                },
                else => continue,
            }

            numBuf = 0;
            continue;
        }
        if (std.ascii.isDigit(c)) {
            std.debug.print("we got a digit: {c}\n", .{c});
            numBuf = numBuf * 10;
            numBuf += try std.fmt.parseInt(u64, &[1]u8{c}, 10);
            std.debug.print("this is our new num: {d}\n", .{numBuf});
        }
    }

    return game;
}
test "sample data" {
    const testData = [_][]const u8{ "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green", "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue", "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red", "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red", "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green" };
    var sum: u64 = 0;
    for (testData, 0..) |line, i| {
        const game: u64 = i + 1;
        var afterColon = false;
        var numBuf: u8 = 0;

        for (line, 0..) |c, j| {
            std.debug.print("this is the current char {c}\n", .{c});
            if (j == line.len - 1) {
                std.debug.print("done checking line\n", .{});
                sum += game;
                break;
            }
            if (c == ':') {
                std.debug.print("we got a colon\n", .{});
                afterColon = true;
                continue;
            }
            if (!afterColon) {
                std.debug.print("we not after colon\n", .{});
                continue;
            }
            if (std.ascii.isAlphabetic(c) and numBuf != 0) {
                std.debug.print("this is number: {}\n", .{numBuf});
                switch (c) {
                    'b' => {
                        if (numBuf > 14) {
                            break;
                        }
                    },
                    'r' => {
                        if (numBuf > 12) {
                            break;
                        }
                    },
                    'g' => {
                        if (numBuf > 13) {
                            break;
                        }
                    },
                    else => continue,
                }

                numBuf = 0;
                continue;
            }
            if (std.ascii.isDigit(c)) {
                std.debug.print("we got a digit: {c}\n", .{c});
                numBuf = numBuf * 10;
                numBuf += try std.fmt.parseInt(u8, &[1]u8{c}, 10);
                std.debug.print("this is our new num: {d}\n", .{numBuf});
            }
        }
    }

    try std.testing.expect(sum == 8);
}
