import Data.Bits
import Data.Char (isAlpha)
import Text.Printf

data OpType = AND | OR | LSHIFT | RSHIFT | NOT | DEFAULT deriving (Show, Eq)

type Wire = (String, Int)

type Instruction = (OpType, String, String, String)

as16 :: Int -> Int
as16 = (.&.) 0xFFFF

op :: OpType -> Int -> Int -> Int
op AND x y = as16 $ x .&. y
op OR x y = as16 $ x .|. y
op LSHIFT x n = as16 $ shiftL x n
op RSHIFT x n = as16 $ shiftR x n

notOp :: Int -> Int
notOp x = as16 $ complement x

parseRowToInstruction :: [String] -> Instruction
parseRowToInstruction parts
  | length parts == 3 = (DEFAULT, wireAt0, "", assign)
  | length parts == 4 = (NOT, wireAt1, "", assign)
  | otherwise = (op, wireAt0, wireAt2, assign)
  where
    assign = last parts
    wireAt0 = head parts
    wireAt1 = parts !! 1
    wireAt2 = parts !! 2
    identifierAt1 = parts !! 1
    op = case identifierAt1 of
      "AND" -> AND
      "OR" -> OR
      "LSHIFT" -> LSHIFT
      "RSHIFT" -> RSHIFT

applyInstruction :: [Wire] -> Instruction -> [Wire]
applyInstruction wires (DEFAULT, x, _, assign) = setOrInsert assign (if all isAlpha x then getVal x wires else read x) wires
applyInstruction wires (NOT, x, _, assign) = setOrInsert assign (notOp (getVal x wires)) wires
applyInstruction wires (LSHIFT, x, y, assign) = setOrInsert assign (op LSHIFT (getVal x wires) (read y)) wires
applyInstruction wires (RSHIFT, x, y, assign) = setOrInsert assign (op RSHIFT (getVal x wires) (read y)) wires
applyInstruction wires (opType, x, y, assign) = setOrInsert assign result wires
  where
    val1 = getValue x wires
    val2 = getValue y wires
    result = op opType val1 val2

getValue :: String -> [Wire] -> Int
getValue s wires =
  if all isAlpha s
    then getVal s wires
    else read s

getVal :: String -> [Wire] -> Int
getVal key wires =
  snd . head $ filter (\(k, _) -> k == key) wires

setOrInsert :: String -> Int -> [Wire] -> [Wire]
setOrInsert key val = ((key, val) :) . filter (\(k, _) -> k /= key)

-- getVal :: String -> [Wire] -> Int
-- getVal key = snd . head . filter (\(k, v) -> k == key)

apply :: [Instruction] -> [Wire] -> [Wire]
apply [] wires = wires
apply ((op, x, y, assign) : xs) wires
  | all (`isAvailable` wires) (filter (/= "") [x, y]) =
      apply xs (applyInstruction wires (op, x, y, assign))
  | otherwise =
      apply (reverse ((op, x, y, assign) : reverse xs)) wires

isAvailable :: String -> [Wire] -> Bool
isAvailable s wires
  | not (all isAlpha s) = True
  | otherwise = s `elem` map fst wires

signalOnA :: [Instruction] -> Int
signalOnA instructions = snd $ head $ filter (\(k, _) -> k == "a") $ apply instructions []

override :: Int -> [Instruction] -> [Instruction]
override val =
  map
    ( \(opType, x, y, assign) ->
        if assign == "b"
          then (DEFAULT, show val, "", "b")
          else (opType, x, y, assign)
    )

main :: IO ()
main = do
  instructions <- map (parseRowToInstruction . words) . lines <$> readFile "input.txt"

  let partOne = signalOnA instructions
  printf "partOne: %d\n" partOne

  let partTwo = signalOnA $ override partOne instructions
  printf "partTwo: %d\n" partTwo
