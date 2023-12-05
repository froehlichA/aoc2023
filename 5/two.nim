import std/options
import std/strutils
import std/sequtils
import std/sugar

let f = open("input.txt")

var seedLine = f.readLine()
seedLine.removePrefix("seeds: ")
var seedLineNrs = seedLine.split(" ").map(parseInt)
var seedRanges = seedLineNrs.distribute((seedLineNrs.len / 2).toInt).map(r => (r[0], r[1]))
discard f.readLine()

proc getMatch(a: (int, int), b: (int, int)): Option[(int, int)] =
  let startVal = max(a[0], b[0])
  let endVal = min(a[0] + a[1], b[0] + b[1])
  let len = endVal - startVal
  if len <= 0:
    return none((int, int))
  return some((startVal, len))

var fromArr = seedRanges
var toArr: seq[(int, int)] = @[]

var line = "xxx"
while f.readLine(line):
  if line.contains(":"):
    continue

  if line == "":
    for i, current in fromArr:
      if current[0] == 0 and current[1] == 0: continue
      toArr.add(current)
    fromArr = toArr
    toArr = @[]
    continue

  let split_line = line.split(" ")
  let dst_start = split_line[0].parseInt
  let src_start = split_line[1].parseInt
  let len = split_line[2].parseInt

  for i, current in fromArr:
    if current[0] == 0 and current[1] == 0: continue
    let matchOpt = getMatch(current, (src_start, len))
    if matchOpt.isSome:
      let match = matchOpt.get
      if match[0] == current[0] and match[1] == current[1]:
        fromArr[i] = (0, 0)
      let nextStart = dst_start + (match[0] - src_start)
      toArr.add((nextStart, match[1]))

for i, current in fromArr:
  if current[0] == 0 and current[1] == 0: continue
  toArr.add(current)

var output = 9999999999999999
for num in toArr:
  if num[0] == 0: continue
  output = min(output, num[0])

echo output

f.close()