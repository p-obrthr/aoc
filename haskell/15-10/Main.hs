import Text.Printf

iteration :: String -> String
iteration = concatMap convert . split
  where
    split [] = []
    split str =
      let (group, rest) = span (== head str) str
       in group : split rest
    convert str = show (length str) ++ [head str]

doIterationTimes :: Int -> String -> String
doIterationTimes 0 str = str
doIterationTimes n str = doIterationTimes (n - 1) (iteration str)

main :: IO ()
main = do
  partOne <-
    doIterationTimes 40 . filter (/= '\n') <$> readFile "input.txt"
  printf "PartOne: %d\n" $ length partOne
  printf "PartTwo: %d\n" $ length $ doIterationTimes 10 partOne
