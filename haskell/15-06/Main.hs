import Data.List (foldl')
import Text.Printf

data Instruction = Instruction
  { identifier :: ModifyType,
    from :: (Int, Int),
    to :: (Int, Int)
  }
  deriving (Show)

data Light = Light
  { x :: Int,
    y :: Int,
    val :: Int
  }
  deriving (Show)

data ModifyType = On | Off | Toggle deriving (Show)

type OpMode = ModifyType -> (Int -> Int)

rowFromString :: String -> Instruction
rowFromString str = Instruction identifier (fromX, fromY) (toX, toY)
  where
    parts = split ' ' str
    identifier
      | length parts /= 5 = Toggle
      | head (tail parts) == "on" = On
      | otherwise = Off
    fromStr = concat $ take 1 $ drop (length parts - 3) parts
    toStr = last parts
    extractInts = map read . split ','
    [fromX, fromY] = extractInts fromStr
    [toX, toY] = extractInts toStr

split :: Char -> String -> [String]
split c input = reverse $ map reverse $ split' c input [] []
  where
    split' _ [] current final = current : final
    split' c str current final
      | head str == c = split' c (tail str) [] (current : final)
      | otherwise = split' c (tail str) (head str : current) final

getOp1 :: OpMode
getOp1 On = const 1
getOp1 Off = const 0
getOp1 Toggle = (1 -)

getOp2 :: OpMode
getOp2 On = (1 +)
getOp2 Off = \x -> max 0 (x - 1)
getOp2 Toggle = (2 +)

modify :: [Light] -> OpMode -> Instruction -> [Light]
modify list getOp (Instruction modType (fromX, fromY) (toX, toY)) =
  map
    ( \light ->
        if x light >= fromX
          && x light <= toX
          && y light >= fromY
          && y light <= toY
          then modify' light
          else light
    )
    list
  where
    modify' (Light x y val) = Light x y (getOp modType val)

initLights :: [Light]
initLights = [Light x y 0 | x <- range, y <- range]
  where
    range = [0 .. 999]

solve :: OpMode -> [Instruction] -> [Light]
solve opMode = foldl' (`modify` opMode) initLights

calc1 :: [Light] -> Int
calc1 = length . filter ((== 1) . val)

calc2 :: [Light] -> Int
calc2 = sum . map val

main :: IO ()
main = do
  instructions <- map rowFromString . lines <$> readFile "input.txt"
  printf "PartOne: %d\n" $ calc1 $ solve getOp1 instructions
  printf "PartTwo: %d\n" $ calc2 $ solve getOp2 instructions
