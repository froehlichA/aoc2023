import Data.Char
import Data.List
import Data.Maybe

type Competition = (Int, Int)

parseInput :: [String] -> Competition
parseInput list = case list of
  x:y:xs -> ((lineToNr "Time:" x),(lineToNr "Distance:" y))
    where lineToNr prefix line = read (filter (not . isSpace) . fromJust $ stripPrefix prefix line) :: Int
  [x] -> (0,0)
  [] -> (0,0)

winningHolds :: Competition -> [Int]
winningHolds competition = [hold_ms | hold_ms <- [0..allowed_ms], (allowed_ms - hold_ms) * hold_ms > record_distance]
  where allowed_ms = fst competition
        record_distance = snd competition

main :: IO()
main = do
  contents <- readFile "input.txt"
  print $ length $ winningHolds $ parseInput $ lines contents