const fs = require('fs');

console.log(
  fs.readFileSync("./input.txt", "utf-8")
    .split("\n")
    .filter(s => !!s)
    .map(l => ({
      nr: Number(l.split(':')[0].replace('Game ', '')),
      games: l.split(':')[1].trim().split(";").map(g => Object.fromEntries(g.split(',').map(p => p.trim().split(' ').reverse().map((v, i) => i === 1 ? Number(v) : v))))
    }))
    .filter(l => l.games.every(v => (v?.red ?? 0) <= 12 && (v?.green ?? 0) <= 13 && (v?.blue ?? 0) <= 14))
    .map(l => l.nr)
    .reduce((a, b) => a + b, 0)
);