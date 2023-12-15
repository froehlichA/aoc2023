const std = @import("std");

const Card = struct {
    nr: i9,
    winning_nrs: [10]i8,
    nrs: [25]i8,
    found: usize,
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
    var allocator = std.heap.page_allocator;
    var input = try std.fs.cwd().openFile("input.txt", .{});
    defer input.close();

    var in_reader = std.io.bufferedReader(input.reader());
    var in_stream = in_reader.reader();
    var buf: [1024]u8 = undefined;

    var card_map = std.AutoHashMap(i9, Card).init(allocator);
    defer card_map.deinit();

    // Construct cards from lines
    while (try in_stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var it = std.mem.split(u8, line, ":");
        var prefix = it.next().?;
        var suffix = it.next().?;

        prefix = std.mem.trimLeft(u8, prefix, "Card ");
        var nr = try std.fmt.parseInt(i9, prefix, 10);

        it = std.mem.split(u8, suffix, "|");
        var winning_nrs = try parseNrStr([10]i8, it.next().?);
        var nrs = try parseNrStr([25]i8, it.next().?);

        var found_nrs: usize = 0;
        for (nrs) |card_nr| {
            var is_found = false;
            for (winning_nrs) |winning_nr| {
                if (card_nr == winning_nr) is_found = true;
            }
            if (is_found) found_nrs += 1;
        }

        var card = Card{
            .nr = nr,
            .winning_nrs = winning_nrs,
            .nrs = nrs,
            .found = found_nrs,
        };
        try card_map.put(nr, card);
    }

    // Process cards
    var card_counts = [_]u32{1} ** 213;
    var index: usize = 0;
    while (index < card_counts.len) : (index += 1) {
        var card_count = card_counts[index];
        var card = card_map.get(@as(i9, @intCast(index)) + 1).?;
        std.debug.print("{} ({}): Adding {} cards: ", .{ card.nr, card_count, card.found });
        if (card.found > 0) {
            for (0..card.found) |offset| {
                var next_card_index = card.nr + @as(i9, @intCast(offset)) + 1;
                std.debug.print("{}x {}, ", .{ card_count, next_card_index });
                card_counts[@as(usize, @intCast(next_card_index)) - 1] += card_count;
            }
        }
        std.debug.print("\n", .{});
    }

    var sum: u64 = 0;
    for (card_counts) |count| {
        sum += count;
    }
    std.debug.print("{}\n", .{sum});
}
