Date cpuSecondsToRun(
  input := File with("input.txt") openForReading()

  Symbol := Object clone do(
    content ::= nil
    index ::= nil
  )
  Num := Symbol clone do(
    fromList ::= method(l,
      n := Num clone setIndex(self index)
      num := 0
      l_size := l size
      l foreach(i, v,
        num = num + (10 ** (l_size - 1 - i)) * v
      )
      n setContent(num)
    )
  )

  digits := list("1", "2", "3", "4", "5", "6", "7", "8", "9", "0")
  is_digit := method(c, digits contains(c))

  num_map := Map clone
  symbol_list := List clone

  # Process lines
  line := nil
  line_nr := 0
  line_length := nil

  while((line = input readLine) != nil,
    if(line_length == nil) then(line_length = line size)
    # Step over characters and discover numbers
    num := list()
    start := 0
    line foreach(i, v,
      idx := line_nr * line_length + start
      if(is_digit(v asCharacter)) then(
        # Add digit to num array
        if(num size == 0) then(start := i)
        num = num append(v asCharacter asNumber)
      ) else(
        # Register num array as Num & reset list
        if(num size > 0) then(
          n := Num clone fromList(num) setIndex(idx)
          num_map = num_map atPut("" .. idx, n)
          num := list()
        )
        if((v asCharacter) != ".") then(
          # Add symbol to map
          idx := line_nr * line_length + i
          s := Symbol clone setContent(v asCharacter) setIndex(idx)
          symbol_list = symbol_list append(s)
        )
      )
    )

    if(num size > 0) then(
      n := Num clone fromList(num) setIndex(idx)
      num_map = num_map atPut("" .. idx, n)
    )

    line_nr = line_nr + 1
  )

  # Discover all part numbers & calculate sum
  part_map := Map clone
  symbol_list foreach(s,
    # Get all numbers in the surrounding area
    nums := list()
    for(i, -1, 1,
      for(j, -3, 3,
        index := s index + (i * line_length) + j
        if(num_map hasKey("" .. index)) then(
          nums = nums append(num_map at("" .. index))
        )
      )
    )
    # Filter for values that touch the symbol
    nums = nums select(n,
      num_indexes := list()
      for(j, 0, n content log10, num_indexes = num_indexes append(n index + j))
      sym_indexes := list()
      for(i, -1, 1, for(j, -1, 1, sym_indexes = sym_indexes append(s index + (i * line_length) + j)))
      num_indexes detect(ni, sym_indexes contains(ni)) != nil
    )

    nums foreach(n,
      part_map = part_map atPut(""..(n index), n)
    )  
  )

  part_map values map(content) reduce(+) println
) println