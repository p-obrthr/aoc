main :: IO ()
main = do
    text <- readFile "input.txt"
    print $ partOne text 
    print $ partTwo text 

partOne :: String -> Int
partOne text = count (map (map extractFirst) $ map words $ splitByEmptyLines text) 0

partTwo :: String -> Int
partTwo text = length $ filterOutBelowSeven $ map filterOutCorrectFieldsAndVals $ getValueTuples text

getValueTuples :: String -> [[(String, String)]]
getValueTuples text = map (map extractBoth) $ map words $ splitByEmptyLines text

filterOutBelowSeven :: [[(String, String)]] -> [[(String, String)]]
filterOutBelowSeven list = filter (\x -> length x >= 7) list

filterOutCorrectFieldsAndVals :: [(String, String)] -> [(String, String)] 
filterOutCorrectFieldsAndVals list = filter checkField list 

isValid :: [(String, String)] -> Bool
isValid [] = False
isValid list 
    | length list < 7 = False 
    | otherwise = False 

checkField :: (String, String) -> Bool
checkField ("byr", val) = checkYear val 1920 2002 
checkField ("iyr", val) = checkYear val 2010 2020 
checkField ("eyr", val) = checkYear val 2020 2030 
checkField ("hgt", val) = checkHgt val 
checkField ("hcl", val) = checkHcl val 
checkField ("ecl", val) = checkEcl val
checkField ("pid", val) = checkPid val
checkField _ = False

checkYear :: String -> Int -> Int -> Bool
checkYear number min max = (read number) >= min && (read number) <= max
 
checkPid :: String -> Bool
checkPid number = length number == 9 &&  all (`elem` "0123456789") number

checkEcl :: String -> Bool
checkEcl x = x `elem` ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]

checkHcl :: String -> Bool
checkHcl ('#':a:b:c:d:e:f:[]) = all (`elem` "0123456789abcdef") [a,b,c,d,e,f]
checkHcl _ = False

checkHgt :: String -> Bool
checkHgt str = checkByMetric $ splitValueMetric str  

checkByMetric :: (String, String) -> Bool
checkByMetric (val, "cm") = (read val) >= 150 && (read val) <= 193 
checkByMetric (val, "in") = (read val) >= 59 && (read val) <= 76 
checkByMetric (_, _) = False 

splitValueMetric :: String -> (String, String)
splitValueMetric str = span (`elem` "0123456789") str

splitByEmptyLines :: String -> [String]
splitByEmptyLines text = map unlines (splitLines (lines text))

splitLines :: [String] -> [[String]]
splitLines [] = []
splitLines ("" : xs) = splitLines xs
splitLines lines =
    let (first, rest) = break (== "") lines
    in first : splitLines rest

extractFirst :: String -> String
extractFirst line =
    let (first, _) = break (== ':') line
    in first

extractBoth :: String -> (String, String)
extractBoth line =
    let (indicator, _ : value) = break (== ':') line
    in (indicator, value)

areAllFieldsIn :: [String] -> Bool
areAllFieldsIn [] = False 
areAllFieldsIn fields
    | length fields < 7 = False 
    | all (`elem` fields) ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"] = True
    | otherwise = False 

count :: [[String]] -> Int -> Int 
count [] acc = acc
count (x:xs) acc
    | areAllFieldsIn x = count xs (acc+1) 
    | otherwise  = count xs acc
