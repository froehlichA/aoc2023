const std = @import("std");

const Card = struct {
    nr: i9,
    winning_nrs: [10]i8,
    nrs: [25]i8,
};

fn parseNrStr(comptime T: type, buf: []const u8) !T {
    var str = std.mem.trim(u8, buf, " ");
    var it = std.mem.split(u8, str, " ");
    var nrs: T = undefined;
    var i: usize = 0;
    while (it.next()) |nr_str| {
        if (std.mem.eql(u8, nr_str, "")) continue;
        nrs[i] = try std.fmt.parseInt(i8, nr_str, 10);
        i += 1;
    }
    return nrs;
}

pub fn main() !void {
    var input = try std.fs.cwd().openFile("input.txt", .{});
    defer input.close();

    var in_reader = std.io.bufferedReader(input.reader());
    var in_stream = in_reader.reader();
    var buf: [1024]u8 = undefined;

    var total_points: usize = 0;

    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var it = std.mem.split(u8, line, ":");
        var prefix = it.next().?;
        var suffix = it.next().?;

        prefix = std.mem.trimLeft(u8, prefix, "Card ");
        var nr = try std.fmt.parseInt(i9, prefix, 10);

        it = std.mem.split(u8, suffix, "|");
        var winning_nrs = try parseNrStr([10]i8, it.next().?);
        var nrs = try parseNrStr([25]i8, it.next().?);

        var card = Card{
            .nr = nr,
            .winning_nrs = winning_nrs,
            .nrs = nrs,
        };

        var found_nrs: usize = 0;
        for (card.nrs) |card_nr| {
            var is_found = false;
            for (card.winning_nrs) |winning_nr| {
                if (card_nr == winning_nr) is_found = true;
            }
            if (is_found) found_nrs += 1;
        }
        var points: usize = 0;
        if (found_nrs > 0) {
            points = std.math.pow(usize, 2, found_nrs - 1);
        }
        total_points += points;
    }

    std.debug.print("{}\n", .{total_points});
}
