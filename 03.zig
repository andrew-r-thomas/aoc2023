const std = @import("std");
const print = std.debug.print;

pub fn main() !void {
    var file = try std.fs.cwd().openFile("./data/03.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();
    var buf: [1024]u8 = undefined;
    var sum: u64 = 0;
    // we might get an error for not checking adj on last char if last char is a num

    var symbols: [140]u8 = [_]u8{0} ** 140;
    var prev_symbols: [140]u8 = [_]u8{0} ** 140;

    var non_adj: [140]u64 = [_]u64{0} ** 140;
    var prev_non_adj: [140]u64 = [_]u64{0} ** 140;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var current_num: u64 = 0;
        for (line, 0..) |c, i| {
            if (std.ascii.isDigit(c)) {
                current_num *= 10;
                current_num += try std.fmt.parseInt(u8, &[1]u8{c}, 10);

                if (i == line.len - 1) {
                    var len: u64 = 0;
                    if (current_num < 10) {
                        len = 1;
                    } else if (current_num < 100) {
                        len = 2;
                    } else {
                        len = 3;
                    }

                    const start: u64 = i - len - 1;
                    const end: u64 = line.len;

                    const slice = prev_symbols[start..end];
                    var adj = false;
                    if (symbols[start] == 1) {
                        adj = true;
                    } else {
                        for (slice) |s| {
                            if (s == 1) {
                                sum += current_num;
                                adj = true;
                                break;
                            }
                        }
                    }
                    if (!adj) {
                        non_adj[start + 1] = current_num;
                    }

                    current_num = 0;
                }
            } else if (c == '.' and current_num != 0) {
                // here we know that we are right after a num, because we set current_num to 0 at the end of this
                // we need to find the length in digits of the number, our max is 3
                var len: u64 = 0;
                if (current_num < 10) {
                    len = 1;
                } else if (current_num < 100) {
                    len = 2;
                } else {
                    len = 3;
                }

                var start: u64 = 0;
                if (i - len > 0) {
                    start = i - len - 1;
                }

                var end: u64 = start + len + 1;
                if (end > 139) {
                    end = 139;
                }

                const slice = prev_symbols[start .. end + 1];
                var adj = false;
                if (symbols[start] == 1) {
                    adj = true;
                } else {
                    for (slice) |s| {
                        if (s == 1) {
                            sum += current_num;
                            adj = true;
                            break;
                        }
                    }
                }
                if (!adj) {
                    if (start == 0) {
                        non_adj[start] = current_num;
                    } else {
                        non_adj[start + 1] = current_num;
                    }
                }

                current_num = 0;
            } else if (c != '.') {
                // ok here we have hit a symbol
                if (current_num != 0) {
                    sum += current_num;
                }

                symbols[i] = 1;
                current_num = 0;
            }
        }
        for (prev_non_adj, 0..) |n, i| {
            if (n != 0) {
                var len: u64 = 0;
                if (n < 10) {
                    len = 1;
                } else if (n < 100) {
                    len = 2;
                } else {
                    len = 3;
                }

                var start: u64 = 0;
                if (i > 0) {
                    start = i - 1;
                }

                var end: u64 = start + len + 1;
                if (end > line.len) {
                    end = line.len;
                }

                const slice = symbols[start..end];

                for (slice) |s| {
                    if (s == 1) {
                        sum += n;
                        break;
                    }
                }
            }
        }
        print("current symbols are: {any}\n", .{symbols});
        print("current non_adj are: {any}\n", .{non_adj});
        print("current sum is: {d}\n", .{sum});
        prev_non_adj = non_adj;
        prev_symbols = symbols;
        non_adj = [_]u64{0} ** 140;
        symbols = [_]u8{0} ** 140;
    }
}

test "test case" {
    const test_data = [_][]const u8{
        "467..114..",
        "...*......",
        "..35...633",
        "......#...",
        "617*......",
        ".....+.58.",
        "..592.....",
        "......755.",
        "...$.*....",
        ".664.598..",
    };

    var sum: u64 = 0;
    // we might get an error for not checking adj on last char if last char is a num

    var symbols: [10]u8 = [_]u8{0} ** 10;
    var prev_symbols: [10]u8 = [_]u8{0} ** 10;

    var non_adj: [10]u64 = [_]u64{0} ** 10;
    var prev_non_adj: [10]u64 = [_]u64{0} ** 10;

    for (test_data) |line| {
        var current_num: u64 = 0;
        for (line, 0..) |c, i| {
            if (std.ascii.isDigit(c)) {
                current_num *= 10;
                current_num += try std.fmt.parseInt(u8, &[1]u8{c}, 10);

                if (i == line.len - 1) {
                    var len: u64 = 0;
                    if (current_num < 10) {
                        len = 1;
                    } else if (current_num < 100) {
                        len = 2;
                    } else {
                        len = 3;
                    }

                    const start: u64 = i - len - 1;
                    const end: u64 = line.len;

                    const slice = prev_symbols[start..end];
                    var adj = false;
                    if (symbols[start] == 1) {
                        adj = true;
                    } else {
                        for (slice) |s| {
                            if (s == 1) {
                                sum += current_num;
                                adj = true;
                                break;
                            }
                        }
                    }
                    if (!adj) {
                        non_adj[start + 1] = current_num;
                    }

                    current_num = 0;
                }
            } else if (c == '.' and current_num != 0) {
                // here we know that we are right after a num, because we set current_num to 0 at the end of this
                // we need to find the length in digits of the number, our max is 3
                var len: u64 = 0;
                if (current_num < 10) {
                    len = 1;
                } else if (current_num < 100) {
                    len = 2;
                } else {
                    len = 3;
                }

                var start: u64 = 0;
                if (i - len > 0) {
                    start = i - len - 1;
                }

                var end: u64 = start + len + 1;
                if (end > 9) {
                    end = 9;
                }

                const slice = prev_symbols[start .. end + 1];
                var adj = false;
                if (symbols[start] == 1) {
                    adj = true;
                } else {
                    for (slice) |s| {
                        if (s == 1) {
                            sum += current_num;
                            adj = true;
                            break;
                        }
                    }
                }
                if (!adj) {
                    if (start == 0) {
                        non_adj[start] = current_num;
                    } else {
                        non_adj[start + 1] = current_num;
                    }
                }

                current_num = 0;
            } else if (c != '.') {
                // ok here we have hit a symbol
                if (current_num != 0) {
                    sum += current_num;
                }

                symbols[i] = 1;
                current_num = 0;
            }
        }
        for (prev_non_adj, 0..) |n, i| {
            if (n != 0) {
                var len: u64 = 0;
                if (n < 10) {
                    len = 1;
                } else if (n < 100) {
                    len = 2;
                } else {
                    len = 3;
                }

                var start: u64 = 0;
                if (i > 0) {
                    start = i - 1;
                }

                var end: u64 = start + len + 1;
                if (end > line.len) {
                    end = line.len;
                }

                const slice = symbols[start..end];

                for (slice) |s| {
                    if (s == 1) {
                        sum += n;
                        break;
                    }
                }
            }
        }
        print("current symbols are: {any}\n", .{symbols});
        print("current non_adj are: {any}\n", .{non_adj});
        print("current sum is: {d}\n", .{sum});
        prev_non_adj = non_adj;
        prev_symbols = symbols;
        non_adj = [_]u64{0} ** 10;
        symbols = [_]u8{0} ** 10;
    }
}
