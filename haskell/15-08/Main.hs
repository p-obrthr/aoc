import Data.Char (isDigit)
import Text.Printf

countChars :: String -> Int
countChars input = countStringData (trimQuote input) 0
  where
    countStringData [] acc = acc
    countStringData ('\\' : 'x' : _ : _ : rest) acc = countStringData rest (acc + 1)
    countStringData ('\\' : _ : rest) acc = countStringData rest (acc + 1)
    countStringData (_ : rest) acc = countStringData rest (acc + 1)
    trimQuote [] = []
    trimQuote str = init $ tail str

main :: IO ()
main = do
  ls <- lines <$> readFile "input.txt"
  printf "partOne: %d\n" $ sum $ map (\x -> length x - countChars x) ls
  printf "partTwo: %d\n" $ sum $ map (\x -> length (show x) - length x) ls
