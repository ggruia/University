-- 1.
-- a)
sfChr :: Char -> Bool
sfChr c = elem c ".?!:"

countSentencesRec :: String -> Int
countSentencesRec [] = 0;
countSentencesRec (x:xs)
    | sfChr x = countSentencesRec xs + 1
    | otherwise = countSentencesRec xs

-- b)
countSentencesSel :: String -> Int
countSentencesSel xs = sum [1 | x <- xs, sfChr x]

-- 2.
liniiN :: [[Int]] -> Int -> Bool
liniiN mat k = all (==True) (map (\line -> if all (>0) line then True else False) (filter (\line -> length line == k) mat))

-- 3.
data Punct = Pt [Int]   deriving Show
data Arb = Vid | F Int | N Arb Arb   deriving Show

class ToFromArb a where
    toArb :: a -> Arb
    fromArb :: Arb -> a

instance ToFromArb Punct where
    toArb (Pt []) = Vid
    toArb (Pt (x:xs)) = N (F x) (toArb (Pt xs))

    fromArb Vid = Pt []
    fromArb (F x) = Pt [x]
    fromArb (N l r) = addToPt (fromArb l) (fromArb r)

addToPt :: Punct -> Punct -> Punct
addToPt (Pt xs) (Pt ys) = Pt (xs ++ ys)