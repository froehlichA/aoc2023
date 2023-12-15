import std/strutils
import std/sequtils
import std/sugar

let f = open("input.txt")

var seedLine = f.readLine()
seedLine.removePrefix("seeds: ")
var seeds = seedLine.split(" ").map(parseInt)
discard f.readLine()

var fromArr = seeds
var toArr: seq[int] = @[]

var line = "xxx"
while f.readLine(line):
  if line.contains(":"):
    continue

  if line == "":
    for i, current in fromArr:
      if current == -1: continue
      fromArr[i] = -1
      toArr.add(current)
    fromArr = toArr
    toArr = @[]
    continue

  let split_line = line.split(" ")
  let dst_start = split_line[0].parseInt
  let src_start = split_line[1].parseInt
  let len = split_line[2].parseInt

  for i, current in fromArr:
    if current == -1: continue
    if current >= src_start and current < (src_start + len):
      let next = dst_start + (current - src_start)
      fromArr[i] = -1
      toArr.add(next)

var output = 9999999999999999
for num in toArr:
  output = min(output, num)

echo output

f.close()