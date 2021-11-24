import Test.QuickCheck
import Data.Char
import Data.Maybe


-- 2.
double :: Int -> Int
double x = x * 2
triple :: Int -> Int
triple x = x * 3
penta :: Int -> Int
penta x = x * 5

-- 3.
test x = (double x + triple x) == (penta x)

-- 4.
-- :t test = test :: Int -> Bool

-- 6.
test' x = (double x * triple x) == (penta x)

-- 7.
myLookUp :: Int -> [(Int, String)]-> Maybe String
myLookUp key [] = Nothing
myLookUp key ((x, str) : xs)
    | x == key = Just str
    | otherwise = myLookUp key xs

testLookUp :: Int -> [(Int, String)] -> Bool
testLookUp x xs = myLookUp x xs == lookup x xs

testLookUpCond :: Int -> [(Int, String)] -> Property
testLookUpCond n list = (n > 0) && (n `div` 5 == 0) ==> testLookUp n list

-- 8.
-- a)
myLookUp' :: Int -> [(Int, String)]-> Maybe String
myLookUp' key [] = Nothing
myLookUp' key ((x, str) : xs)
    | x == key && str == [] = Just ""
    | x == key = Just (toUpper(head str) : tail str)
    | otherwise = myLookUp' key xs

-- b)
testLookUp' :: Int -> [(Int, String)] -> Property
testLookUp' key xs = xs == filter (\(x, xss) -> if xss == "" then False else if head xss == toUpper(head xss) then True else False) xs ==> myLookUp' key xs == lookup key xs

-- Arbitrary.
data ElemIS = I Int | S String deriving (Show, Eq)

instance Arbitrary ElemIS where
    arbitrary = do
        x <- arbitrary
        str <- arbitrary
        elements[I x, S str]

-- 9.
myLookUpElem :: Int -> [(Int, ElemIS)]-> Maybe ElemIS
myLookUpElem x xs
    | length lst == 0 = Nothing
    |otherwise = Just (head lst)
        where lst = [str | (key, str) <- xs, key == x]

testLookUpElem :: Int -> [(Int, ElemIS)] -> Bool
testLookUpElem x xs = myLookUpElem x xs == lookup x xs
