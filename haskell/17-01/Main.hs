import Data.Char (digitToInt)
import Text.Printf

main = do
  xs <- map digitToInt . head . lines <$> readFile "input.txt"
  let solve xs n = sum [x | (x, y) <- zip xs (drop n (cycle xs)), x == y]
  printf "partOne: %d\n" (solve xs 1)
  printf "partTwo: %d\n" (solve xs (length xs `div` 2))
