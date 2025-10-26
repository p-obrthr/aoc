main :: IO ()
main = do
  text <- readFile "input.txt"
  let intList = convertToInt $ lines text
  print $ multiplyTuple $ getTuple intList 
  print $ multiplyThree $ getThree intList 

convertToInt :: [String] -> [Int]
convertToInt list = map read list

getTuple :: [Int] -> (Int, Int) 
getTuple intList = head [ (x, y) | x <- intList, y <- intList, x <= y,  x + y == 2020 ] 

multiplyTuple :: (Int, Int) -> Int
multiplyTuple (x, y) = x * y

getThree :: [Int] -> (Int, Int, Int)
getThree intList = head [ (x, y, z) | x <- intList, y <- intList, z <- intList, x <= y && y <= z,  x + y + z == 2020 ] 

multiplyThree :: (Int, Int, Int) -> Int
multiplyThree (x, y, z) = x * y * z

