import Text.Printf

main = do
  lines <- map (map (read :: String -> Int) . words) . lines <$> readFile "input.txt"
  let solve mapFunc = sum . map mapFunc $ lines
  printf "partOne: %d\n" $ solve (\xs -> maximum xs - minimum xs)
  printf "partTwo: %d\n" $ solve (\xs -> head [x `div` y | x <- xs, y <- xs, x `mod` y == 0, x /= y])
