module nine;

import std.algorithm;
import std.array;
import std.conv;
import std.stdio;
import std.string;
import std.file;
import std.parallelism;

int[] computeDiff(int[] input) {
    return computeDiffRec([input]);
}

int[] computeDiffRec(int[][] stack) {
    int[] last = stack.back;
    int[] output = [];
    for(int i = 0; i < last.length - 1; i++) {
        output ~= last[i + 1] - last[i];
    }
    stack ~= output;

    bool isDone = true;
    foreach(num; output) {
        if(num != output[0]) {
            isDone = false;
        }
    }

    if(isDone) {
        return collapseRec(stack);
    } else {
        return computeDiffRec(stack);
    }
    return last;
}

int[] collapseRec(int[][] stack) {
    if(stack.length == 1) return stack[0];

    int diff = stack.back[0];
    stack.popBack();
    stack.back = [stack.back[0] - diff] ~ stack.back;
    return collapseRec(stack);
}

void main() {
    auto file = readText("input.txt");
    auto lines = splitLines(file);
    int[][] input = [];
    foreach(line; lines) {
        auto splitLine = line.split(" ");
        int[] outputLine = [];
        foreach(numString; splitLine) {
            outputLine ~= to!int(numString);
        }
        input ~= outputLine;
    }

    int[][] output = [];
    foreach (line; input) {
        output ~= computeDiff(line);
    }

    int sum = 0;
    foreach (line; output) {
        sum += line[0];
    }
    writeln(sum);
}