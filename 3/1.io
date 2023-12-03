input := File with("input.txt") asBuffer
line_length := input split("\n") at(0) size + 1

digits := list("1", "2", "3", "4", "5", "6", "7", "8", "9", "0")
is_digit := method(c, digits contains (c))
symbols := (
  i := input clone removeSeq(".") removeSeq("\n")
  digits foreach(d, i = i removeSeq(d))
  i asList unique
)
is_symbol := method(c, symbols contains (c))

engine_nums := Map clone

parse_num := method(str, str clone removeSeq(".") asNumber)

Num := Object clone do(
  number ::= nil
  index ::= nil
  fromList ::= method(l,
    n := Num clone setIndex(index)
    num := 0
    for(i, 0, l size - 1,
      num = num + (10 ** (l size - 1 - i)) * (l at(i))
    )
    n setNumber(num)
    n
  )
  touch ::= method(i,
    num_areas := list()
    for(j, 0, number log10, num_areas = num_areas append(index + j))
    touch_areas := list(
      i - line_length - 1,
      i - line_length + 0,
      i - line_length + 1,
      i - 1,
      i + 1,
      i + line_length - 1,
      i + line_length + 0,
      i + line_length + 1
    )
    touches := false
    num_areas foreach (a,
      (touch_areas contains(a)) ifTrue(touches := true)
    )
    touches
  )
)

input foreach(i, v,
  is_symbol(v asCharacter) ifTrue(
    up_pos := i - line_length
    down_pos := i + line_length
    # Compute number in areas around v
    areas := list(
      list(up_pos - 3, up_pos + 3),
      list(i - 3, i - 1),
      list(i + 1, i + 3),
      list(down_pos - 3, down_pos + 3)
    )

    input inclusiveSlice(up_pos - 3, up_pos + 3) println
    input inclusiveSlice(i - 3, i + 3) println
    input inclusiveSlice(down_pos - 3, down_pos + 3) println

    nums := list()
    areas foreach(area_pos,
      area := input inclusiveSlice(area_pos at(0), area_pos at(1))
      area_characters := area asList map(i, v, list(v, i + (area_pos at(0))))
      # Compute numbers
      partial_nums := list()
      for(j, 0, (area_characters size) - 1,
        area_character := area_characters at(j)
        character := area_character at(0)
        index := area_character at(1)
        is_digit(character) ifTrue(
          partial_nums = partial_nums append(area_character)
        ) ifFalse(
          (partial_nums size > 0) ifTrue(
            num := Num clone setIndex(partial_nums at(0) at(1)) fromList(partial_nums map(n, n at(0) asNumber))
            nums = nums append(num)
          )
          partial_nums = list()
        )
      )
      (partial_nums size > 0) ifTrue(
        num := Num clone setIndex(partial_nums at(0) at(1)) fromList(partial_nums map(n, n at(0) asNumber))
        nums = nums append(num)
      )
    )

    # Filter out numbers that do not touch i
    nums = nums select(n, n touch(i))
    writeln("COMPUTED => ", nums)
    # Add numbers to map
    nums foreach(num,
      engine_nums = engine_nums atPut("" .. (num index), num)
    )
    writeln("===")
  )
)

engine_nums values map(n, n number) reduce(+) println