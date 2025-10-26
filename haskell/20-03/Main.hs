main :: IO ()
main = do
  text <- readFile "input.txt"
  print $ partOne $ lines text
  print $ partTwo $ lines text


partOne :: [String] -> Int
partOne lines = countTrees lines 1 1 3 0 

partTwo :: [String] -> Int
partTwo lines = product $ map (\(d,p,r) -> countTrees lines d p r 0) 
                               [(1,1,1),(1,1,3),(1,1,5),(1,1,7),(2,1,1)]

countTrees :: [String] -> Int -> Int -> Int -> Int -> Int 
countTrees [] _ _ _ acc = acc
countTrees lines down pos right acc 
    | remainingLines == [] = acc 
    | checkOnPosition (head remainingLines) nextPos = countTrees remainingLines down nextPos right (acc + 1) 
    | otherwise = countTrees remainingLines down nextPos right acc 
  where
    remainingLines = drop down lines
    nextPos = ((pos + right -1) `mod` (length (head remainingLines))) + 1

checkOnPosition :: String -> Int -> Bool 
checkOnPosition line pos 
    | line !! (pos - 1) == '#' = True
    | otherwise = False

