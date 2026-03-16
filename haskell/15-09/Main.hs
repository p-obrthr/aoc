import Data.List (elemIndex, nub)
import Data.Maybe (fromJust)
import Text.Printf

calculate :: [((Int, Int), Int)] -> [Int] -> ([Int] -> Int) -> [([Int], Int, Int)]
calculate distances cities selector = table
  where
    table =
      [ (set, endCity, selectCost set endCity)
        | set <- sets,
          endCity <- set
      ]

    sets = filter (/= []) $ sets' cities
    sets' [] = [[]]
    sets' (x : xs) =
      let rest = sets' xs
       in rest ++ [x : s | s <- rest]

    selectCost [x] _ = 0
    selectCost set endCity =
      selector
        [ getCost table (remove endCity set) prevCity
            + findDist distances prevCity endCity
          | prevCity <- remove endCity set
        ]

    getCost table s j =
      head
        [ c
          | (s', j', c) <- table,
            s' == s,
            j' == j
        ]

    remove = filter . (/=)

    findDist m a b =
      head [d | ((x, y), d) <- m, x == a, y == b]

parse :: String -> ((String, String), Int)
parse line =
  let [from, _, to, _, d] = words line
   in ((from, to), read d)

build :: [((String, String), Int)] -> ([String], [((Int, Int), Int)])
build routes = (citiesUnique, distInds)
  where
    citiesUnique = nub [c | ((a, b), _) <- routes, c <- [a, b]]

    distInds =
      [ ((getId x, getId y), d)
        | ((a, b), d) <- routes,
          (x, y) <- [(a, b), (b, a)]
      ]

    getId = fromJust . (`elemIndex` citiesUnique)

solve :: [((Int, Int), Int)] -> [String] -> ([Int] -> Int) -> Int
solve distances citiesUnique selector =
  selector [c | (s, _, c) <- table, s == citiesInds]
  where
    citiesInds = [0 .. length citiesUnique - 1]
    table = calculate distances citiesInds selector

main :: IO ()
main =
  readFile "input.txt"
    >>= \input ->
      let (citiesUnique, distances) = build $ map parse $ lines input
          solver = solve distances citiesUnique
       in do
            printf "PartOne: %d\n" $ solver minimum
            printf "PartTwo: %d\n" $ solver maximum
