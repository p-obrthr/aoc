import Data.Char (isDigit)
import Text.Printf

data Mode = Curly | Square deriving (Eq)

type Frame = (Mode, Int, Bool)

solve :: Bool -> String -> Int
solve redFilter = extract' [(Square, 0, False)]
  where
    extract' [(_, total, _)] [] = total
    extract' stack ('{' : xs) = extract' ((Curly, 0, False) : stack) xs
    extract' stack ('[' : xs) = extract' ((Square, 0, False) : stack) xs
    extract' (curr : parent : rest) ('}' : xs) =
      let toAdd = if redFilter && isRed curr then 0 else getSum curr
       in extract' (add toAdd parent : rest) xs
    extract' (curr : parent : rest) (']' : xs) =
      let toAdd = getSum curr
       in extract' (add toAdd parent : rest) xs
    extract' ((m, s, r) : rest) ('r' : 'e' : 'd' : xs)
      | redFilter && m == Curly = extract' ((m, s, True) : rest) xs
      | otherwise = extract' ((m, s, r) : rest) xs
    extract' ((m, s, r) : restStack) (x : xs)
      | x == '-' || isDigit x =
          let (num, restStr) = span (\x -> x == '-' || isDigit x) (x : xs)
           in extract' ((m, s + read num, r) : restStack) restStr
    extract' stack (_ : xs) = extract' stack xs

    getSum (_, s, _) = s
    isRed (_, _, r) = r
    add x (m, s, r) = (m, s + x, r)

main :: IO ()
main = do
  readFile "input.txt" >>= \input ->
    do
      printf "PartOne: %d\n" $ solve False input
      printf "PartTwo: %d\n" $ solve True input
