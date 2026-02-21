import Text.Printf

floorChange :: Int -> Char -> Int
floorChange floor '(' = floor + 1
floorChange floor ')' = floor - 1
floorChange floor _ = floor

partOne :: [Char] -> Int -> Int
partOne xs floor = foldl floorChange floor xs

partTwo :: [Char] -> Int -> Int -> Int
partTwo _ floor pos | floor == -1 = pos
partTwo (x : xs) floor pos = partTwo xs (floorChange floor x) (pos + 1)

main :: IO ()
main = do
  input <- readFile "input.txt"
  printf "PartOne: %d\n" $ partOne input 0
  printf "PartTwo: %d\n" $ partTwo input 0 0
