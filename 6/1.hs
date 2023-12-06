import Data.List
import Data.Maybe

type Competition = (Int, Int)

parseInput :: [String] -> [Competition]
parseInput list = case list of
  x:y:xs -> zip (lineToNrs "Time:" x) (lineToNrs "Distance:" y)
    where lineToNrs prefix line = map read (words $ fromJust $ stripPrefix prefix line) :: [Int]
  [x] -> []
  [] -> []

winningHolds :: Competition -> [Int]
winningHolds competition = [hold_ms | hold_ms <- [0..allowed_ms], (allowed_ms - hold_ms) * hold_ms > record_distance]
  where allowed_ms = fst competition
        record_distance = snd competition

main :: IO()
main = do
  contents <- readFile "input.txt"
  print $ product $ map length . map winningHolds . parseInput $ lines contents