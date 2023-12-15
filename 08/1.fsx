open System.Text.RegularExpressions

let (|Regex|_|) pattern input =
  let m = Regex.Match(input, pattern)
  if m.Success then Some(List.tail [ for g in m.Groups -> g.Value ])
  else None
let parseWay content = match content with
  | Regex @"([A-Z]{3}) = \(([A-Z]{3}), ([A-Z]{3})\)" [ input; left; right ] -> Some((input, left, right))
  | _ -> None

let lines = System.IO.File.ReadAllLines("input.txt")
let instructions = lines.[0] |> Seq.toList
let wayList = 
  lines.[2..]
  |> Array.toList
  |> List.map parseWay
  |> List.map (fun x -> x.Value)
let ways =
  wayList
  |> List.fold (fun map (key, left, right) -> Map.add key (left, right) map) Map.empty


let main =
  let mutable current = "AAA"
  let mutable idx = 0
  while current <> "ZZZ" do
    let instruction = instructions.[idx % instructions.Length]
    let (left, right) = Map.find current ways
    let next = if instruction = 'L' then left else right
    current <- next
    idx <- idx + 1
  printfn "%A" idx

main
