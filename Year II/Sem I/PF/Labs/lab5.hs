{-
MAP     :    map :: (a -> b) -> [a] -> [b]                  aplica F pe x <- [xs]
FILTER  :    filter :: (a -> Bool) -> [a] -> [b]            selecteaza x <- [xs] care indeplinesc predicatul P
FOLDR   :    foldr :: (a -> b) -> Int -> [Int] -> Int       aplica F "recursiv" pe [xs] la "dreapta"
-}


-- 1.
firstEl :: [(a, b)] -> [a]
firstEl = map fst

-- 2.
sumList :: [[Int]] -> [Int]
sumList = map sum

-- 3.
prel2 :: [Int] -> [Int]
prel2 = map (\x -> if even x then x `div` 2 else x * 2)

-- 4.
inStr :: Char -> [String] -> [String]
inStr c = filter (elem c)

-- 5.
squareOddNums :: [Int] -> [Int]
squareOddNums xs = map (^2) (filter odd xs)

-- 6.
squareOddPos :: [Int] -> [Int]
squareOddPos xs = map (^2) (map fst (filter (odd.snd) (zip xs [0..])))

-- 7.
noConsonant :: [String] -> [String]
noConsonant = (map.filter) (`elem` "aeiouAEIOU")

-- 8.
mymap :: (a -> b) -> [a] -> [b]
mymap f [] = []
mymap f (x:xs) = f x : mymap f xs

myfilter :: (a -> Bool) -> [a] -> [a]
myfilter p [] = []
myfilter p (x:xs)
    | p x = x : myfilter p xs
    | otherwise = myfilter p xs

-- 9.
sumSquaresOddNums :: [Int] -> Int
sumSquaresOddNums xs = sum (map (^2) (filter odd xs))

-- 10.
allTrue :: [Bool] -> Bool
allTrue xs = foldr (&&) True xs

-- 11.
rmChar :: Char -> String -> String
rmChar c = filter (/= c)

rmCharsRec :: String -> String -> String
rmCharsRec [] xs = xs
rmCharsRec (x:xs) xss = rmCharsRec xs (rmChar x xss)

rmCharsFold :: String -> String -> String
rmCharsFold = flip (foldr rmChar)