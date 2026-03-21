import Data.List (nub)

isValid :: [Int] -> Bool
isValid ints =
  anyIncrease ints && notContainIOL ints && nonOverlapping ints
  where
    anyIncrease (x : y : z : rest)
      | isIncrease [x, y, z] = True
      | otherwise = anyIncrease (y : z : rest)
    anyIncrease _ = False
    isIncrease [x, y, z] =
      x >= 97 && y == x + 1 && z == y + 1 && z <= 122
    isIncrease _ = False
    notContainIOL = all (`notElem` map fromEnum "iol")
    nonOverlapping xs = length (nub (pairs xs)) >= 2
      where
        pairs (x : y : zs)
          | x == y = x : pairs zs
          | otherwise = pairs (y : zs)
        pairs _ = []

next :: [Int] -> [Int]
next = reverse . increment . reverse
  where
    increment = increment' []
    increment' acc [] = acc
    increment' acc (122 : xs) = increment' (97 : acc) xs
    increment' acc (x : xs) = reverse (x + 1 : acc) ++ xs

getNextValid :: [Int] -> [Int]
getNextValid = until isValid next

solve :: String -> String
solve = map toEnum . getNextValid . next . map fromEnum

main :: IO ()
main = do
  let input = "vzbxkghb"
  let partOne = solve input
  putStrLn $ "PartOne: " ++ partOne
  let partTwo = solve partOne
  putStrLn $ "PartTwo: " ++ partTwo
