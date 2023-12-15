const fs = require('fs');

console.table(
  fs.readFileSync("./input.txt", "utf-8")
    .split("\n")
    .filter(s => !!s)
    .map(s => ['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine'].reduce((v, r, i) => v.replace(new RegExp(r, 'g'), r + (i + 1) + r), s))
    .map(s => s.replace(/[a-z]/g, ''))
    .map(s => s.split('').at(0) + s.split('').at(-1))
    .map(s => Number.parseInt(s))
    .reduce((a, b) => a + b, 0)
);