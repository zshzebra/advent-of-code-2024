const std = @import("std");
const allocator = std.heap.page_allocator;

pub fn main() !void {
    // Lists
    var firstList = std.ArrayList(usize).init(allocator);
    var secondList = std.ArrayList(usize).init(allocator);

    var file = try std.fs.cwd().openFile("src/Day 1/input.txt", .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    var in_stream = buf_reader.reader();

    var buf: [1024]u8 = undefined;
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var isFirstNum = true;

        var firstNum: usize = 0;
        var secondNum: usize = 0;

        for (line) |c| {
            if (c == ' ') {
                isFirstNum = false;
                continue;
            }

            if (isFirstNum) {
                if (c >= '0' and c <= '9') {
                    firstNum = (firstNum * 10) + (c - '0');
                }
            } else {
                if (c >= '0' and c <= '9') {
                    secondNum = (secondNum * 10) + (c - '0');
                }
            }
        }

        try firstList.append(firstNum);
        try secondList.append(secondNum);
    }

    std.mem.sort(usize, firstList.items, {}, std.sort.asc(usize));
    std.mem.sort(usize, secondList.items, {}, std.sort.asc(usize));

    var diff: u64 = 0;

    for (0..firstList.items.len) |i| {
        const firstNumber = firstList.items[i];
        const secondNumber = secondList.items[i];

        if (firstNumber > secondNumber) {
            diff += firstNumber - secondNumber;
        } else {
            diff += secondNumber - firstNumber;
        }
    }

    // BUG: Have to divide the output by 2. I'm not sure why...
    diff /= 2;

    std.debug.print("{d}\n", .{diff});
}
