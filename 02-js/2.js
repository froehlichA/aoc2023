const fs = require('fs');

console.log(
  fs.readFileSync("./input.txt", "utf-8")
    .split("\n")
    .filter(s => !!s)
    .map(l => ({
      nr: Number(l.split(':')[0].replace('Game ', '')),
      games: l.split(':')[1].trim().split(";").map(g => Object.fromEntries(g.split(',').map(p => p.trim().split(' ').reverse().map((v, i) => i === 1 ? Number(v) : v))))
    }))
    .map(l => ({
      ...l,
      games: l.games.reduce((a, b) => ({ green: Math.max(a.green, b?.green ?? 0), red: Math.max(a.red, b?.red ?? 0), blue: Math.max(a.blue, b?.blue ?? 0) }), { green: 0, red: 0, blue: 0 })
    }))
    .map(l => l.games.green * l.games.red * l.games.blue)
    .reduce((a, b) => a + b, 0)
);