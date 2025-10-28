import Data.List (sort)

main :: IO ()
main = do
    text <- readFile "input.txt"
    let list = map calculate $ map intTupleConvert $ map splitIntoRowAndColumn $ map convert $ lines text
    putStrLn $ show $ partOne list
    putStrLn $ show $ partTwo $ sort list

convert :: String -> String
convert str = map convertChar str 

convertChar :: Char -> Char
convertChar 'F' = '0'
convertChar 'B' = '1'
convertChar 'L' = '0'
convertChar 'R' = '1'

splitIntoRowAndColumn :: String -> (Int, Int)
splitIntoRowAndColumn str = (read (take 7 str), read (drop 7 str))

intTupleConvert :: (Int, Int) -> (Int, Int)
intTupleConvert (x, y)  = (binToDec x, binToDec y)

binToDec :: Int -> Int
binToDec 0 = 0
binToDec x = (x `mod` 10) + 2 * binToDec (x `div` 10)

calculate :: (Int, Int) -> Int
calculate (row, col) = row * 8 + col

partOne :: [Int] -> Int
partOne list = findBiggest list 0

findBiggest :: [Int] -> Int -> Int
findBiggest [] acc = acc
findBiggest (x:xs) acc
    | x > acc = findBiggest xs x 
    | otherwise = findBiggest xs acc 

partTwo :: [Int] -> Int
partTwo list = findGap $ sort list

findGap :: [Int] -> Int 
findGap [] = -1
findGap (x:y:zs)
    | y - x == 2 = y - 1
    | otherwise = findGap (y:zs) 
