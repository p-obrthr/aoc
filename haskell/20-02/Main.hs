main :: IO ()
main = do
  text <- readFile "input.txt"
  putStrLn $ show $ partOne (lines text) 0
  putStrLn $ show $ partTwo (lines text) 0

partOne :: [String] -> Int -> Int
partOne [] acc = acc
partOne (x:xs) acc 
    | checkMinMax (parseLine x) == True    = partOne xs (acc+1) 
    | otherwise = partOne xs acc 

parseLine :: String -> (Int, Int, Char, String)
parseLine line =
    let [range, charWithColon, password] = words line
        (firstNumStr,_:secondNumStr) = break (== '-') range
    in (read firstNumStr, read secondNumStr, head charWithColon, password)

checkMinMax :: (Int, Int, Char, String) -> Bool
checkMinMax (min, max, charVal, password)
    | (countChar password charVal 0) >= min && (countChar password charVal 0) <= max = True 
    | otherwise = False 

countChar :: String -> Char -> Int -> Int
countChar [] _ acc = acc
countChar (x:xs) c acc 
    | x == c    = countChar xs c (acc + 1)
    | otherwise = countChar xs c acc

partTwo :: [String] -> Int -> Int
partTwo [] acc = acc
partTwo (x:xs) acc
    | checkPosition (parseLine x) = partTwo xs (acc + 1) 
    | otherwise = partTwo xs acc 

checkPosition :: (Int, Int, Char, String) -> Bool
checkPosition (positionOne, positionTwo, charVal, password) 
    | (isOnPosition password charVal positionOne) `xor` (isOnPosition password charVal positionTwo) = True
    | otherwise = False 

isOnPosition :: String -> Char -> Int -> Bool
isOnPosition password charVal pos = password !! (pos - 1) == charVal

xor :: Bool -> Bool -> Bool
xor a b = (a || b) && not (a && b)

